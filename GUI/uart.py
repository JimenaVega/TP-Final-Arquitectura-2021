import time
import serial
import struct

class Uart():
    def __init__(self, port, baudrate=9600):
        # self.ser = serial.serial_for_url(port, timeout=1)
        print("UART PORT = ", port)
        self.ser = serial.Serial(
            port     = port,	#Configurar con el puerto
            baudrate = 19200,
            parity   = serial.PARITY_NONE,
            stopbits = serial.STOPBITS_ONE,
            bytesize = serial.EIGHTBITS
        )

        self.ser.isOpen()
        self.ser.timeout=None
        self.ser.flushInput()
        self.ser.flushOutput()

        print(self.ser.timeout)
        print("Interfaz utilizada:", self.ser.name) 

    def send_command(self, command):
        # self.ser.reset_output_buffer()
        print('UART: Envio de comando...')

        # self.ser.flushInput()
        # self.ser.flushOutput()

        # byte_data = command & 0xFF
        # self.ser.write(struct.pack('B', byte_data))

        byte_msg = command.to_bytes(1, 'big')
        print("command: ", byte_msg)
        self.ser.write(byte_msg)

        

        

    def send_file(self, file_name):    
        print('UART: Comenzando con el envío...')

        #INPUT_FILE_NAME = '../translator/r_inst_bin.txt'
      
        # fp = open(file_name, 'r')
        # line_byte = int(fp.readline(), 2).to_bytes(1, 'big')
        # count = 0

        # while True:
        #     # Envío por Tx
        #     self.ser.write(line_byte)    
        #     print("[{0}] byte enviado: {1}".format(count, line_byte))

        #     self.read_byte()
        #     # Lectura de siguiente byte
        #     line = fp.readline()
        #     count += 1
        #     if line:
        #         line_byte = int(line, 2).to_bytes(1, 'big')
        #     else:
        #         break 
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
        

    def receive_file(self, to_save, max_bytes):
        """
        Guarda en un archivo con nombre definido por "to_save" los elementos que llegan de la UART
        to_save : nombre del archivo donde se van a guardar
        max_bytes : cantidad de bytes maxima a recibir. Debe ser multiplo de 4.
        """
        print("UART: Comenzando a recibir bytes...")
        if((max_bytes % 4) != 0):
            return
        
        try:
            with open(to_save, "w") as file:
                bytes_received = 0
                while bytes_received < max_bytes:
                    data = self.ser.read(4)
                    file.write(data.decode() + "\n") # TODO: Ver como se formatea data para que quede en binario string
                    bytes_received += len(data)
        except serial.SerialException as e:
            print("Error during data reception:", e)

        self.ser.reset_input_buffer()

    def read_byte(self):
        out = ''
        while self.ser.inWaiting() > 0:
            out += '{0}'.format(self.ser.read(1))
        if out != '':
            print("Read >> ", out)

    def byte_to_bistring(self, intnum):
        # intnum = 15
        bistring = bin(intnum)[2:]  # Obtiene la representación binaria y omite el prefijo "0b"
        bistring = bistring.zfill(8)  # Rellena con ceros a la izquierda hasta tener 8 bits

        print(bistring)  # Imprime el string binario resultante
        return bistring
    
    def ascii_to_int(self, ascii_array):
        """
        Convierte un ascii array de 4 bytes de largo (un string) en un string de representacion binaria de 32 bits de largo.
        """
        byte_string = ""
        for ascii in ascii_array: # TODO: ver si el orden en que se apendean los strings es correcto (LSB al MSB)
            byte_string = byte_string + self.byte_to_bistring(int(ascii))


        pass

    def bistring_to_byte(self, bistring):
        byte = int(bistring.strip(), 2).to_bytes(1, 'big')   
        print("Byte = ", byte)
        return byte 

# def main():

    

#     fp = open(INPUT_FILE_NAME, 'r')
#     line_byte = int(fp.readline(), 2).to_bytes(1, 'big')
#     count = 0

#     while True:
#         # Envío por Tx
#         ser.write(line_byte)    
#         print("[{0}] byte enviado: {1}".format(count, line_byte))

#         # Recepción por Rx
#         #time.sleep(2)
#         out = ''
#         #print "Info: ",ser.inWaiting()
#         while ser.inWaiting() > 0:
#             out += '{0}'.format(ser.read(1))
#         if out != '':
#             print(">> ", out)
        
#         # Lectura de siguiente byte
#         line = fp.readline()
#         count += 1
#         if line:
#             line_byte = int(line, 2).to_bytes(1, 'big')
#         else:
#             break 

#     ser.close()    
#     fp.close()   
#     exit()     

# if __name__ == "__main__":
#     main()