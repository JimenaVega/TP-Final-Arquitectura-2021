import tkinter as tk
from uart import Uart

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
    def __init__(self):
        self.window = tk.Tk()
        self.window.config(bd=15)

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
        # self.monitor.config(text=commands.get(self.option.get()))


gui = GUI()