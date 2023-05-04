import time
import serial

ser = serial.serial_for_url('loop://', timeout=1)

# ser = serial.Serial(
#     port     = '/dev/ttyUSB1',	#Configurar con el puerto
#     baudrate = 9600,
#     parity   = serial.PARITY_NONE,
#     stopbits = serial.STOPBITS_ONE,
#     bytesize = serial.EIGHTBITS
# )

ser.isOpen()
ser.timeout=None
ser.flushInput()
ser.flushOutput()

print(ser.timeout)
print("Interfaz utilizada:", ser.name) 
print('Comenzando con el envío...')

INPUT_FILE_NAME = '../translator/r_inst_bin.txt'

def main():

    ser.flushInput()
    ser.flushOutput()

    fp = open(INPUT_FILE_NAME, 'r')
    line_byte = int(fp.readline(), 2).to_bytes(1, 'big')
    count = 0

    while True:
        # Envío por Tx
        ser.write(line_byte)    
        print("[{0}] byte enviado: {1}".format(count, line_byte))

        # Recepción por Rx
        #time.sleep(2)
        out = ''
        #print "Info: ",ser.inWaiting()
        while ser.inWaiting() > 0:
            out += '{0}'.format(ser.read(1))
        if out != '':
            print(">> ", out)
        
        # Lectura de siguiente byte
        line = fp.readline()
        count += 1
        if line:
            line_byte = int(line, 2).to_bytes(1, 'big')
        else:
            break 

    ser.close()    
    fp.close()   
    exit()     

if __name__ == "__main__":
    main()