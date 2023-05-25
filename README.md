# Procesador segmentado de 5 etapas MIPS IV

Trabajo final de arquitectura de computadoras 2022. Facultad de Ciencias Exactas

Para el uso de la GUI, instalar:

```
sudo apt update
python -m pip install pyserial
sudo apt-get install python3-tk
```

Para usar uart chequear que el usuario pertenezca a el grupo dialout, sino agregar:

```
groups ${USER}
sudo gpasswd --add ${USER} dialout
```
