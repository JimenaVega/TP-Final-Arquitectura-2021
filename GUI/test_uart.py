import time
import serial
import signal

# Port busy: sudo lsof /dev/ttyUSB0
# sudo kill -9
#ser = serial.serial_for_url('loop://', timeout=1)

def handler(signum, frame):
    msg = "Ctrl-c was pressed. "
    print(msg)
    ser.reset_input_buffer()
    ser.reset_output_buffer()    
    ser.close() 
    exit()
 
def byte_to_bistring(intnum):
    # intnum = 15
    converted = int.from_bytes(intnum, 'big')
    bistring = bin(converted)[2:]  # Obtiene la representación binaria y omite el prefijo "0b"
    bistring = bistring.zfill(8)  # Rellena con ceros a la izquierda hasta tener 8 bits
    
    print("R: ", bistring)  # Imprime el string binario resultante

    return bistring

ser = serial.Serial(
            port     = '/dev/ttyUSB0',	#Configurar con el puerto
            baudrate = 19200,
            parity   = serial.PARITY_NONE,
            stopbits = serial.STOPBITS_ONE,
            bytesize = serial.EIGHTBITS
        )

signal.signal(signal.SIGINT, handler)

def main():

    ser.reset_input_buffer()
    ser.reset_output_buffer()

    # fp = open(INPUT_FILE_NAME, 'r')
    # line_byte = int(fp.readline(), 2).to_bytes(1, 'big')
    # count = 0
    print("WAITING FOR UART:")
    while True:
       
        out = ''
        #print "Info: ",ser.inWaiting()
        while ser.inWaiting() > 0:
            received = ser.read(1)
            out += '{0}'.format(received)
            byte_to_bistring(received)
        if out != '':
            print(">> ", out)
        
     
    ser.close()    
    fp.close()   
    exit()     

if __name__ == "__main__":
    main()()    
# fp.close() 