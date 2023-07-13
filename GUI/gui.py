import tkinter as tk
from uart import Uart
from translator import translate_file

COMMAND_1 = "Escribir programa"
COMMAND_2 = "Ejecucion continua"
COMMAND_3 = "Step by step"
COMMAND_4 = "Leer bank register"
COMMAND_5 = "Leer data memory"
COMMAND_6 = "Leer PC"
COMMAND_7 = "Send step"
COMMAND_8 = "Continue >>"

commands = {1: COMMAND_1,
            2: COMMAND_2,
            3: COMMAND_3,
            4: COMMAND_4,
            5: COMMAND_5,
            6: COMMAND_6,
            7: COMMAND_7,
            8: COMMAND_8,
            }

DATA_MEMORY_SIZE = 128  # 128 bytes of depth
REGISTER_BANK_SIZE = 128  # 32 * 4 bytes
PC_SIZE = 4  # 4 bytes
INS_MEM_SIZE = 256  # lineas
DATA_MEMORY_FILE = 'data_memory.txt'
REGISTER_BANK_FILE = 'register_bank.txt'
PC_FILE = 'program_counter.txt'

commands_files = {4: [REGISTER_BANK_FILE, REGISTER_BANK_SIZE],
                  5: [DATA_MEMORY_FILE, DATA_MEMORY_SIZE],
                  6: [PC_FILE, PC_SIZE]}


class GUI:
    def __init__(self, instruction_file, uart_port='loop://', baudrate=19200):

        self.next_action = {1: self.send_program,
                            4: self.receive_file,
                            5: self.receive_file,
                            6: self.receive_file, }

        #file_name = translate_file(instruction_file)
        self.uart = Uart(uart_port, baudrate)

        self.instruction_file = instruction_file
        self.instruction_size = 0  # Necesario para saber cuantos steps mandar
        
        self.window = tk.Tk()  # Main menu
        self.window.config(bd=80)
        self.window.title("GUI: Main menu")
        
        self.ex_window = None  # Execution window
        self.debug_window = None  # Debug window
        self.maximum_steps = None
        self.sent_step = 0
        self.step_msg = ""
        
        self.start_msg = tk.Label(text="Elegir una opción: ")
        self.start_msg.grid(column=0, row=0)
        self.start_msg.pack()
        
        self.option = tk.IntVar()
        self.exe_mode = None
        
        tk.Radiobutton(self.window, text=commands.get(1), variable=self.option, value=1).pack()
        tk.Radiobutton(self.window, text=commands.get(4), variable=self.option, value=4).pack()
        tk.Radiobutton(self.window, text=commands.get(5), variable=self.option, value=5).pack()
        tk.Radiobutton(self.window, text=commands.get(6), variable=self.option, value=6).pack()
        
        tk.Button(self.window, text="Send", command=self.send_command).pack()
        
        self.window.mainloop()

    def send_command(self):
        print(commands.get(self.option.get()))

        # Se envía comando por UART
        command = self.option.get()
        self.uart.send_command(command)

        # Siguiente funcion a ejecutar
        if command == 1:
            self.next_action.get(command)()
        else:
            self.next_action.get(command)(commands_files.get(command)[0], commands_files.get(command)[1])

    def send_program(self):
        # Se convierte el archivo con instrucciones a 'binario'
        file_name, file_size = translate_file(self.instruction_file)
        print('file name: ', file_name)

        # Se envia por uart el .mem y se ejecuta la siguiente ventana
        self.instruction_size = int(self.uart.send_file(file_name) / 4)
        self.maximum_steps = file_size + 4

        self.set_execution_window()

    def receive_file(self, file_name, file_size):
        """
        Llama al UART RX para guardar un nuevo archivo.
        to_save : nombre del archivo donde se van a guardar
        max_bytes : cantidad de bytes maxima a recibir. Debe ser multiplo de 4.
            Por ejemplo: DATA_MEMORY_SIZE 
        """

        # Se envía comando por UART
        command = self.option.get()
        print("Command: ", commands.get(command))
        self.uart.send_command(command)

        mem_type = "br" if command == 4 else "" # Determina si se imprime el nombre del registro

        self.uart.receive_file(file_name, file_size, mem_type)


    def set_execution_window(self):

        self.ex_window = tk.Toplevel()  # Execution window

        self.ex_window.config(bd=30)
        self.ex_window.title("GUI: Ejecucion")
        self.exe_mode = tk.IntVar()

        tk.Label(self.ex_window, text="Elegir modo de ejecución: ").pack()

        tk.Radiobutton(self.ex_window, text=commands.get(2), variable=self.exe_mode, value=2).pack()
        tk.Radiobutton(self.ex_window, text=commands.get(3), variable=self.exe_mode, value=3).pack()
        tk.Button(self.ex_window, text="Send", command=self.send_execution_mode).pack()

    def send_execution_mode(self):

        mode = self.exe_mode.get()
        self.uart.send_command(mode)
        print("Execution mode: ", commands.get(mode))

        if mode == 2:
            self.ex_window.destroy()  # Ejecucion continua
        elif mode == 3:
            self.set_debug_window()  # Ejecucion step by step

    def set_debug_window(self):

        self.debug_window = tk.Toplevel()  # Debug window
        self.debug_window.maxsize(900, 800)
        self.debug_window.title("GUI: step by step")

        top_frame = tk.Frame(self.debug_window, width=500, height=400, borderwidth=2)
        top_frame.grid(row=0, column=0, padx=10, pady=5)

        bottom_frame = tk.Frame(self.debug_window, width=500, height=400, borderwidth=2)
        bottom_frame.grid(row=1, column=0, padx=10, pady=5)

        tk.Button(top_frame, text=commands.get(7), command=self.send_step).pack()
        tk.Button(top_frame, text=commands.get(8), command=self.abort_step).pack()

        msg = f'Steps sent: {self.sent_step} \nSteps left: {self.maximum_steps}'
        self.step_msg = tk.Label(bottom_frame, text=msg, borderwidth=2, relief="groove")
        self.step_msg.config(padx=3, pady=3, bd=2)
        self.step_msg.pack()

    def send_step(self):

        print("Maximum steps = ", self.maximum_steps)
        # Send step command 
        if self.maximum_steps <= 0:
            self.debug_window.destroy()
            self.ex_window.destroy()
        else:
            command = 7
            print("STEP")
            self.sent_step += 1

            self.uart.send_command(command)
            self.uart.receive_all(PC_SIZE, REGISTER_BANK_SIZE, DATA_MEMORY_SIZE)

            self.maximum_steps = self.maximum_steps - 1

            msg = f'Steps sent: {self.sent_step} \n Steps left: {self.maximum_steps}'
            self.step_msg.config(text=msg)

    def abort_step(self):
        # Se envía comando de aborto por UART y se continua con ejecucion.
        command = 8
        self.uart.send_command(command)
        self.debug_window.destroy()
        self.ex_window.destroy()


instruction_file = "jump_test"
uart_port = '/dev/ttyUSB1'
gui = GUI(instruction_file, uart_port)
