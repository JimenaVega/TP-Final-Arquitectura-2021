import time
import serial
import numpy as np

NB_DATA_MEM = 128
NB_BANK_REG = 128
NB_PC       = 4

class Uart():
    def __init__(self, port, baudrate=19200):
        # self.ser = serial.serial_for_url(port, timeout=1)
        print("UART PORT = ", port)
        self.ser = serial.Serial(
            port     = port,	#Configurar con el puerto
            baudrate = baudrate,
            parity   = serial.PARITY_NONE,
            stopbits = serial.STOPBITS_ONE,
            bytesize = serial.EIGHTBITS
        )

        # self.allData = np.zeros(NB_DATA_MEM+NB_BANK_REG + NB_PC, dtype=np.int8)
        self.allData = []
        self.ser.isOpen()
        self.ser.timeout=None
        self.ser.flushInput()
        self.ser.flushOutput()

        print(self.ser.timeout)
        print("Interfaz utilizada:", self.ser.name) 

    def send_command(self, command):
        print('UART: Envio de comando...')

        byte_msg = command.to_bytes(1, 'big')
        print("command: ", byte_msg)
        self.ser.write(byte_msg)
        

    def send_file(self, file_name):    
        print('UART: Comenzando con el envío...')

        count = 0
        try:
            with open(file_name, "r") as file:
                for line in file:
                    data = self.bistring_to_byte(line)
                    self.ser.write(data)

                    print("[{0}] byte enviado: {1}".format(count, line))
                    count += 1
        except (FileNotFoundError, serial.SerialException) as e:
            print("Error during data transmission:", e)    
         
        print("DONE sending file")
        self.ser.reset_output_buffer()
        return count
    
    def write_32bits(self, file, max_bytes):

        shift = 24
        data = 0
        address = 0
        bytes_received = 0

        while bytes_received < max_bytes:
            byte_received = self.ser.read(1)
            #print("raw binary = ", byte_received)
            data = data | (int.from_bytes(byte_received, "big") << shift)
        
            if shift == 0:
                self.write_line(file, data, address, 32)
                shift = 24
                data = 0
                address = address + 1
            else:     
                shift = shift - 8

            bytes_received = bytes_received + 1
    
    def write_8bits(self, file, max_bytes):

        address = 0 
        bytes_received = 0

        while bytes_received < max_bytes:

            byte_received = self.ser.read(1)        # UART RX
            #print("raw binary = ", byte_received)

            data = int.from_bytes(byte_received, "big")
            self.write_line(file, data, address)

            bytes_received = bytes_received + 1
            address = address + 1

    def receive_file(self, to_save, max_bytes, mode=32): 
        """
        Guarda en un archivo con nombre definido por "to_save" los elementos que llegan de la UART
        to_save : nombre del archivo donde se van a guardar
        max_bytes : cantidad de bytes maxima a recibir. Debe ser multiplo de 4.
        mode: Cada renglon del archivo tendrá 32 bits o 8 bits.
        """
        print("UART: Comenzando a recibir bytes...")
        if((max_bytes % 4) != 0):
            print("UART ERROR: bytes are not multiple of 4.")
            return
        
        # print("max_bytes: ", max_bytes)
        try:
            with open(to_save, "w") as file:
                if mode==32:
                    self.write_32bits(file, max_bytes)
                elif mode==8:
                    self.write_8bits(file, max_bytes)
                else: 
                    print("Non existent mode.")
                    exit()
                
        except serial.SerialException as e:
            print("Error during data reception:", e)

        self.ser.reset_input_buffer()       

    def receive_all(self):
        """ 
        A diferencia de los otros metodos, este recibe todos los bytes de todas las memorias primero y luego las guarda
        o las imprime en archivos.
        max_bytes: es el total de bytes de todas las memorias/registros que se quieren recibir por uart.
        """
        
        max_bytes = NB_DATA_MEM + NB_BANK_REG + NB_PC
        bytes_received = 0
        byte_index = 0

        while bytes_received < max_bytes:

            byte_received = self.ser.read(1)        # UART RX

            data = int.from_bytes(byte_received, "big")
            # print(f'[{bytes_received}]DATA: {self.byte_to_bistring(data, 8)}')
            self.allData.append(self.byte_to_bistring(data, 8))

            bytes_received = bytes_received + 1

        print("-------------------------------------------------")
        print("PC")
        with open("pc_debug.txt", "w") as file:
            line = "{0}{1}{2}{3}\n".format(self.allData[0], self.allData[1], self.allData[2], self.allData[3])
            print(line)
            file.write(line)
        
        print("-------------------------------------------------")
        print("BANK REGISTER")
        with open("br_debug.txt", "w") as file:
            for i in range(NB_PC, NB_PC+NB_BANK_REG, 4):
                print(f'[{byte_index}] line')
                byte_index += 1
                line = "{0}{1}{2}{3}\n".format(self.allData[0+i], self.allData[1+i], self.allData[2+i], self.allData[3+i])
                file.write(line)
            byte_index = 0    

        print("-------------------------------------------------")
        print("DATA MEMORY")
        with open("dm_debug.txt", "w") as file:
            for i in range(NB_PC+NB_BANK_REG, NB_PC+NB_BANK_REG+NB_DATA_MEM):
                print(f'[{byte_index}] {line}')
                byte_index += 1
                file.write(self.allData[i] + "\n")

    def write_line(self, file, bytes_data, address, bin_size=8):
        decimal_data = bytes_data
        bistring_data = self.byte_to_bistring(bytes_data, bin_size)
        hex_data = hex(decimal_data)

        line = "[{0}] B: {1} | D: {2} | H: {3}".format(address, bistring_data, decimal_data, hex_data) + "\n"
        print("LINE: ", line)
        file.write(line)

    def byte_to_bistring(self, intnum, size=8):
        # intnum = 15
        bistring = bin(intnum)[2:]  # Obtiene la representación binaria y omite el prefijo "0b"
        bistring = bistring.zfill(size)  # Rellena con ceros a la izquierda hasta tener "size" bits

        # print(bistring)  # Imprime el string binario resultante
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
        print("Byte = ", byte)
        return byte 
