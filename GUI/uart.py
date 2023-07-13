import time
import serial
import numpy as np

registers = ['zero', 'at', 'v0', 'v1',
             'a0', 'a1', 'a2', 'a3',
             't0', 't1', 't2', 't3',
             't4', 't5', 't6', 't7',
             's0', 's1', 's2', 's3',
             's4', 's5', 's6', 's7',
             't8', 't9', 'k0', 'k1',
             'gp', 'sp', 'fp', 'ra']

NB_DATA_MEM = 128
NB_BANK_REG = 128
NB_PC       = 4

class Uart():
    def __init__(self, port, baudrate=19200):
    
        self.ser = None
        try:
            self.ser = serial.Serial(
                port     = port,	
                baudrate = baudrate,
                parity   = serial.PARITY_NONE,
                stopbits = serial.STOPBITS_ONE,
                bytesize = serial.EIGHTBITS
            )
        except serial.SerialException as e:
            print(f'Invalid port {port} .')
            exit()

        if self.ser is not None: 
            self.allData = []
            self.ser.isOpen()
            self.ser.timeout=None
            self.ser.flushInput()
            self.ser.flushOutput()
            print(f'Port: {self.ser.port} \nBaudrate: {self.ser.baudrate} \nTimeout: {self.ser.timeout}')
        

    def send_command(self, command):
        byte_msg = command.to_bytes(1, 'big')
        self.ser.write(byte_msg)
        

    def send_file(self, file_name):    
        print('UART: Sending data...')
        count = 0

        try:
            with open(file_name, "r") as file:
                for line in file:
                    data = self.bistring_to_byte(line)
                    self.ser.write(data)

                    print("[{0}] sent byte: {1}".format(count, line))
                    count += 1
        except (FileNotFoundError, serial.SerialException) as e:
            print("Error during data transmission:", e)    
         
        print("DONE sending file.")
        self.ser.reset_output_buffer()
        return count
    
    def write_32bits(self, file, max_bytes, mem_type):
        """
        Imprime en consola de a 4 bytes. Para esto shiftea los bytes hasta que completa
        4.
        """

        shift = 24
        data = 0
        address = 0
        bytes_received = 0

        while bytes_received < max_bytes:
            byte_received = self.ser.read(1)
            data = data | (int.from_bytes(byte_received, "big") << shift)
        
            if shift == 0:
                self.write_line(data, address, mem_type, file)
                shift = 24
                data = 0
                address = address + 1
            else:     
                shift = shift - 8

            bytes_received = bytes_received + 1

    def receive_file(self, to_save, max_bytes, mem_type): 
        """
        Guarda en un archivo con nombre definido por "to_save" los elementos que llegan de la UART
        y tambien imprime por consola el resultado.

        to_save : nombre del archivo donde se van a guardar
        max_bytes : cantidad de bytes maxima a recibir. Debe ser multiplo de 4.
        mem_type: Si es "br" entonces se van a imprimir los nombres de registros.
        """
        print("UART: receiving bytes...")
        if((max_bytes % 4) != 0):
            print("UART ERROR: bytes are not multiple of 4.")
            return
     
        try:
            with open(to_save, "w") as file:
                self.write_32bits(file, max_bytes, mem_type)
                
        except serial.SerialException as e:
            print("Error during data reception:", e)

        self.ser.reset_input_buffer()       
    
    def write_line_debug(self, mem_type, byte_index, i):
        bistring_32 = ""
        line = f'{[byte_index]}'

        if mem_type == "br":
            line += f' {registers[byte_index]} '

        for j in range(4):
            bistring_32 += self.allData[j+i]

        decimal = int(bistring_32, 2)
        line += f' B: {bistring_32} | D: {decimal}' 
        line += "\n"   

        return line  

    def receive_all(self, nb_pc, nb_rb, nb_dm):
        """ 
        A diferencia de los otros metodos, este recibe todos los bytes de todas las memorias primero y luego las guarda
        o las imprime en archivos. Esto es para evitar perdidas de datos.
        max_bytes: es el total de bytes de todas las memorias/registros que se quieren recibir por uart.
        """
        
        bytes_received = 0
        byte_index = 0
        max_bytes =  nb_pc + nb_rb + nb_dm

        while bytes_received < max_bytes:

            byte_received = self.ser.read(1)        # UART RX
            data = int.from_bytes(byte_received, "big")
            self.allData.append(self.byte_to_bistring(data, 8))
            bytes_received = bytes_received + 1

        print("-------------------------------------------------")
        print("DATA MEMORY")
        byte_index = 0 
        for i in range(nb_pc, nb_pc+nb_dm, 4):
            print(self.write_line_debug("dm", byte_index, i))
            byte_index += 1

        print("-------------------------------------------------")
        print("BANK REGISTER")
        byte_index = 0
        for i in range(nb_pc+nb_dm, nb_pc+nb_dm+nb_rb, 4):
            print(self.write_line_debug("br", byte_index, i))
            byte_index += 1

        print("-------------------------------------------------")
        print("PC")
        print(self.write_line_debug("pc", byte_index, 0))
     
                    
        self.allData = []
        
 
    def write_line(self, bytes_data, address, mem_type, file=None):
        """
        Formatea los datos y los imprime en consola. 
        Opcional: file para guardar en un archivo la linea.
        """
        decimal_data = bytes_data
        bistring_data = self.byte_to_bistring(bytes_data, 32)
        hex_data = hex(decimal_data)
        reg = ""

        if mem_type == 'br':
            reg  = registers[address]

        line = "[{0}] {1} B: {2} | D: {3} | H: {4}".format(address, reg, bistring_data, decimal_data, hex_data) + "\n"
        print(line)

        if file is not None: 
            file.write(line)

    def byte_to_bistring(self, bytes_data, size=8):
        bistring = bin(bytes_data)[2:]  # Obtiene la representación binaria y omite el prefijo "0b"
        bistring = bistring.zfill(size)  # Rellena con ceros a la izquierda hasta tener "size" bits

        return bistring
    
    def ascii_to_int(self, ascii_array):
        """
        Convierte un ascii array de 4 bytes de largo (un string) en un string de representacion binaria de 32 bits de largo.
        """
        byte_string = ""
        for ascii in ascii_array: # TODO: ver si el orden en que se apendean los strings es correcto (LSB al MSB)
            byte_string = byte_string + self.byte_to_bistring(int(ascii))


    def bistring_to_byte(self, bistring):
        byte = int(bistring.strip(), 2).to_bytes(1, 'big')   
        return byte 
