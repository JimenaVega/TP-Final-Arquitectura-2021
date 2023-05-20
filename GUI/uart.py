import time
import serial
import struct

class Uart():
    def __init__(self, port, baudrate=9600):
        self.ser = serial.serial_for_url(port, timeout=1)

        # self.ser = serial.Serial(
        #     port     = '/dev/ttyUSB1',	#Configurar con el puerto
        #     baudrate = 9600,
        #     parity   = serial.PARITY_NONE,
        #     stopbits = serial.STOPBITS_ONE,
        #     bytesize = serial.EIGHTBITS
        # )

        self.ser.isOpen()
        self.ser.timeout=None
        self.ser.flushInput()
        self.ser.flushOutput()

        print(self.ser.timeout)
        print("Interfaz utilizada:", self.ser.name) 

    def send_command(self, command):
        print('Comenzando con el envío...')

        self.ser.flushInput()
        self.ser.flushOutput()

        # byte_data = command & 0xFF
        # self.ser.write(struct.pack('B', byte_data))

        byte_msg = command.to_bytes(1, 'big')
        self.ser.write(byte_msg)


    def send_file(self, file_name):    
        print('Comenzando con el envío...')

        #INPUT_FILE_NAME = '../translator/r_inst_bin.txt'
        self.ser.flushInput()
        self.ser.flushOutput()

        fp = open(file_name, 'r')
        line_byte = int(fp.readline(), 2).to_bytes(1, 'big')
        count = 0

        while True:
            # Envío por Tx
            self.ser.write(line_byte)    
            print("[{0}] byte enviado: {1}".format(count, line_byte))

            # Lectura de siguiente byte
            line = fp.readline()
            count += 1
            if line:
                line_byte = int(line, 2).to_bytes(1, 'big')
            else:
                break 
        self.ser.close()    
        fp.close()   
        exit()

    def receive_file(self, to_save):
        """
        Guarda en un archivo con nombre definido por "to_save" los elementos que llegan de la UART
        """
        # TODO: 
        while self.ser.inWaiting() > 0:
            out += '{0}'.format(self.ser.read(1))
        if out != '':
            print(">> ", out)
        self.ser.close()    
        # fp.close()   
        exit()   

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