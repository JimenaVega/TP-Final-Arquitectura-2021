import time
import serial
import struct

ser = serial.Serial(
            port='/dev/ttyUSB0',  # Configurar con el puerto
            baudrate=19200,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            bytesize=serial.EIGHTBITS
        )

ser.reset_input_buffer()
ser.reset_output_buffer() 

print("WRITING")

for i in range(2):
  
    #time.sleep(0.5)
    ser.write(b'H')   # send the pyte string 'H'
    #time.sleep(0.5)   # wait 0.5 seconds
    ser.write(b'L')   # send the byte string 'L'   

ser.close()

print("Done writing")    