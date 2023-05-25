import tkinter as tk
from uart import Uart
from translator import translate_file

COMMAND_A = "Escribir programa"
COMMAND_B = "Ejecucion continua"
COMMAND_C = "Step by step"
COMMAND_D = "Leer bank register"
COMMAND_E = "Leer data memory"
COMMAND_F = "Leer PC"

commands = {1: COMMAND_A,
            2: COMMAND_B,
            3: COMMAND_C,
            4: COMMAND_D,
            5: COMMAND_E,
            6: COMMAND_F}



class GUI():
    def __init__(self, instruction_file, uart_port='loop://'):

        self.next_action = {1: self.send_program,
                            4: self.receive_file,
                            5: self.receive_file,
                            6: self.receive_file}

        self.uart = Uart(uart_port)

        self.instruction_file = instruction_file

        self.window = tk.Tk()   # Main menu
        self.window.config(bd=80)
        self.window.title("GUI: Main menu")

        self.ex_window = None     # Execution window
        self.debug_window = None     # Debug window

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
        self.next_action.get(command)()

        # self.monitor.config(text=commands.get(self.option.get()))

    def send_program(self):

        # Se convierte el archivo con instrucciones a 'binario'
        file_name = translate_file(self.instruction_file)
        print('file name: ',file_name)

        # Se envia por uart el .mem y se ejecuta la siguiente ventana
        self.uart.send_file(file_name)
        self.set_execution_window()
        
    
    def receive_file(self):
        print("receive_file")
        

    def set_execution_window(self):
        print("New window")
        self.ex_window = tk.Toplevel()     # Execution window
        
        self.ex_window.config(bd=30)
        self.ex_window.title("GUI: Ejecucion")
        # self.ex_window.grab_set()
        self.exe_mode = tk.IntVar()
        

        tk.Label(self.ex_window, text="Elegir modo de ejecución: ").pack()

        
        tk.Radiobutton(self.ex_window, text=commands.get(2), variable=self.exe_mode, value=2).pack()
        tk.Radiobutton(self.ex_window, text=commands.get(3), variable=self.exe_mode, value=3).pack()
        print("mode: ", self.exe_mode.get())
        tk.Button(self.ex_window, text="Send", command=self.send_execution_mode).pack()
        

        # self.ex_window.mainloop()

    def send_execution_mode(self):

        mode = self.exe_mode.get()
        print("mode: ", mode)
        # self.uart.send_command(mode)
        print("send execution mode: ", commands.get(mode))

        if mode == 2:
            self.ex_window.destroy() # Ejecucion continua
        elif mode == 3:
            self.set_debug_window()

    def set_debug_window(self):
        self.debug_window = tk.Toplevel()   # Debug window
        self.debug_window.geometry('300x100')
        self.debug_window.title("GUI: step by step")

        tk.Button(self.debug_window, text="Send step", command=self.send_step).pack()
        # self.debug_window.mainloop()

    def send_step(self):
        print("STEP")

instruction_file = "raw_hazard"
uart_port = '/dev/ttyS0'
gui = GUI(instruction_file)