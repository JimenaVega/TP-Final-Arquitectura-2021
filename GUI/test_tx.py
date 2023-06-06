import time
import serial
import struct
import signal

ser = serial.Serial(
            port='/dev/ttyUSB0',  # Configurar con el puerto
            baudrate=19200,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            bytesize=serial.EIGHTBITS
        )

ser.reset_input_buffer()
ser.reset_output_buffer() 

def handler(signum, frame):
    msg = "Ctrl-c was pressed. "
    print(msg)
    ser.reset_input_buffer()
    ser.reset_output_buffer()    
    ser.close() 
    exit()

def bistring_to_byte(bistring):
        byte = int(bistring.strip(), 2).to_bytes(1, 'big')   
        print("Byte = ", byte)
        return byte 

signal.signal(signal.SIGINT, handler)
print("WRITING")

count = 0
try:
    with open("register_bank.mem", "r") as file:
        for line in file:
            data = bistring_to_byte(line)
            ser.write(data)

            print("[{0}] byte enviado: {1}".format(count, line))
            count += 1
except (FileNotFoundError, serial.SerialException) as e:
    print("Error during data transmission:", e)    
    
print("DONE sending file")
ser.close()

print("Done writing")    