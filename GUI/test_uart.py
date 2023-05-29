import time
import serial

# Port busy: sudo lsof /dev/ttyUSB0
# sudo kill -9
#ser = serial.serial_for_url('loop://', timeout=1)

ser = serial.Serial(
            port     = '/dev/ttyUSB0',	#Configurar con el puerto
            baudrate = 19200,
            parity   = serial.PARITY_NONE,
            stopbits = serial.STOPBITS_ONE,
            bytesize = serial.EIGHTBITS
        )

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
            out += '{0}'.format(ser.read(1))
        if out != '':
            print(">> ", out)
        
     
    ser.close()    
    fp.close()   
    exit()     

if __name__ == "__main__":
    main()()    
# fp.close() 