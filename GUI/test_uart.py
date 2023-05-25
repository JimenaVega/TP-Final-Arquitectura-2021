import time
import serial

ser = serial.serial_for_url('loop://', timeout=1)

# ser = serial.Serial(
#             port     = '/dev/ttyS0',	#Configurar con el puerto
#             baudrate = 19200,
#             parity   = serial.PARITY_NONE,
#             stopbits = serial.STOPBITS_ONE,
#             bytesize = serial.EIGHTBITS
#         )

def main():

    ser.flushInput()
    ser.flushOutput()

    # fp = open(INPUT_FILE_NAME, 'r')
    # line_byte = int(fp.readline(), 2).to_bytes(1, 'big')
    # count = 0
    print("WAITING FOR UART:")
    while True:
        # Envío por Tx
        # ser.write(line_byte)    
        # print("[{0}] byte enviado: {1}".format(count, line_byte))

        # Recepción por Rx
        #time.sleep(2)
       
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