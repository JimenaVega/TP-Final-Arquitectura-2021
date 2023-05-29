import tkinter as tk
from uart import Uart
from translator import translate_file

COMMAND_A = "Escribir programa"
COMMAND_B = "Ejecucion continua"
COMMAND_C = "Step by step"
COMMAND_D = "Leer bank register"
COMMAND_E = "Leer data memory"
COMMAND_F = "Leer PC"
COMMAND_G = "Send step"

commands = {1: COMMAND_A,
            2: COMMAND_B,
            3: COMMAND_C,
            4: COMMAND_D,
            5: COMMAND_E,
            6: COMMAND_F,
            7: COMMAND_G,
            }

DATA_MEMORY_SIZE = 64  # In lines of 32bits
REGISTER_BANK_SIZE = 32  # In lines of 32bits
PC_SIZE = 1
DATA_MEMORY_FILE = 'data_memory.txt'
REGISTER_BANK_FILE = 'register_bank.txt'
PC_FILE = 'program_counter.txt'

commands_files = {4: [REGISTER_BANK_FILE, REGISTER_BANK_SIZE],
                  5: [DATA_MEMORY_FILE, DATA_MEMORY_SIZE],
                  6: [PC_FILE, PC_SIZE]}


class GUI():
    def __init__(self, instruction_file, uart_port='loop://', baudrate=19200):

        self.next_action = {1: self.send_program,
                            4: self.receive_file,
                            5: self.receive_file,
                            6: self.receive_file, }

        self.uart = Uart(uart_port, baudrate)

        self.instruction_file = instruction_file
        self.instruction_size = 0  # Necesario para saber cuantos steps mandar

        self.window = tk.Tk()  # Main menu
        self.window.config(bd=80)
        self.window.title("GUI: Main menu")

        self.ex_window = None  # Execution window
        self.debug_window = None  # Debug window
        self.maximum_steps = 0

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
        # if command == 1:
        #     self.next_action.get(command)()
        # else:
        #     self.next_action.get(command)(commands_files.get(command)[0], commands_files.get(command)[1])
        # self.monitor.config(text=commands.get(self.option.get()))

    def send_program(self):
        pass
        # Se convierte el archivo con instrucciones a 'binario'
        # file_name = translate_file(self.instruction_file)
        # print('file name: ',file_name)

        # Se envia por uart el .mem y se ejecuta la siguiente ventana
        # self.instruction_size = self.uart.send_file(file_name)
        # self.maximum_steps = self.instruction_size * 5

        # self.set_execution_window()

    def receive_file(self, file_name, file_size):
        """
        Llama al UART RX para guardar un nuevo archivo.
        to_save : nombre del archivo donde se van a guardar
        max_bytes : cantidad de bytes maxima a recibir. Debe ser multiplo de 4.
            Por ejemplo: DATA_MEMORY_SIZE * 4
        """

        print("receive_file")
        # self.uart.receive_file(file_name, file_size)

    def set_execution_window(self):

        self.ex_window = tk.Toplevel()  # Execution window

        self.ex_window.config(bd=30)
        self.ex_window.title("GUI: Ejecucion")
        # self.ex_window.grab_set()
        self.exe_mode = tk.IntVar()

        tk.Label(self.ex_window, text="Elegir modo de ejecución: ").pack()

        tk.Radiobutton(self.ex_window, text=commands.get(2), variable=self.exe_mode, value=2).pack()
        tk.Radiobutton(self.ex_window, text=commands.get(3), variable=self.exe_mode, value=3).pack()
        tk.Button(self.ex_window, text="Send", command=self.send_execution_mode).pack()

    def send_execution_mode(self):

        mode = self.exe_mode.get()
        print("mode: ", mode)
        self.uart.send_command(mode)
        print("send execution mode: ", commands.get(mode))

        if mode == 2:
            self.ex_window.destroy()  # Ejecucion continua
        elif mode == 3:
            self.set_debug_window()  # Ejecucion step by step

    def set_debug_window(self):

        self.debug_window = tk.Toplevel()  # Debug window
        self.debug_window.geometry('300x100')
        self.debug_window.title("GUI: step by step")

        tk.Button(self.debug_window, text=commands.get(7), command=self.send_step).pack()

    def send_step(self):

        print("maximum_steps = ", self.maximum_steps)
        # Send step command 
        if self.maximum_steps <= 0:
            self.debug_window.destroy()
        else:
            command = 7
            print("STEP")
            self.uart.send_command(command)
            # self.receive_file(REGISTER_BANK_FILE, REGISTER_BANK_SIZE * 4)   # TODO: Ver si realmente se pueden mandar por separado los archivos
            # self.receive_file(DATA_MEMORY_FILE, DATA_MEMORY_SIZE * 4)
            # self.receive_file(PC_FILE, PC_SIZE * 4)
            self.maximum_steps = self.maximum_steps - 1


instruction_file = "two_inst"
uart_port = '/dev/ttyUSB0'
gui = GUI(instruction_file, uart_port)
