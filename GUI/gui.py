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
    def __init__(self, instruction_file):

        self.next_action = {1: self.send_program,
                            2: self.show_main_window,
                            3: self.debug_mode,
                            4: self.receive_file}

        self.uart = Uart('loop://')

        self.instruction_file = instruction_file

        self.window = tk.Tk()
        self.window.config(bd=30)

        self.start_msg = tk.Label(text="Elegir una opción: ")
        self.start_msg.grid(column=0, row=0)
        self.start_msg.pack()

        self.option = tk.IntVar()

        tk.Radiobutton(self.window, text=commands.get(1), variable=self.option, value=1).pack()
        tk.Radiobutton(self.window, text=commands.get(4), variable=self.option, value=4).pack()
        tk.Radiobutton(self.window, text=commands.get(5), variable=self.option, value=5).pack()
        tk.Radiobutton(self.window, text=commands.get(6), variable=self.option, value=6).pack()

        tk.Button(self.window, text="Send", command=self.send_command).pack()
       
        self.window.mainloop()


    def send_command(self):
        print(commands.get(self.option.get()))
        command = self.option.get()
        self.uart.send_command(command)

        # siguiente funcion a ejecutar:
        self.next_action.get(command)()

        # self.monitor.config(text=commands.get(self.option.get()))

    def send_program(self):
        print("llamando a translate: ")
        translate_file(self.instruction_file)
        
    def show_main_window(self):
        pass
    def debug_mode(self):
        pass
    def receive_file(self):
        pass
    

instruction_file = "raw_hazard"
gui = GUI(instruction_file)