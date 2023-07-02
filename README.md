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

## Instrucciones de ejemplo

```
    add $s0,$s1,$s2;
    addu $s0,$s1,$s2;
    sub $s0,$s1,$s2;
    subu $s0,$s1,$s2;
    and $s0,$s1,$s2;
    nor $s0,$s1,$s2;
    or $s0,$s1,$s2;
    xor $s0,$s1,$s2;
    slt $s0,$s1,$s2;
    sll $s0,$s1,3;
    srl $s0,$s1,3;
    sra $s0,$s1,3;
    sllv $s0,$s1,$s2;
    srlv $s0,$s1,$s2;
    srav $s0,$s1,$s2;
    lb $s0,2($t0);
    lh $s0,2($t0);
    lhu $s0,2($t0);
    lw $s0,2($t0);
    lwu $s0,2($t0);
    lbu $s0,2($t0);
    sb $s0,2($t0);
    sh $s0,2($t0);
    sw $s0,2($t0);
    addi $s0,$s1,255;
    andi $s0,$s1,255;
    ori $s0,$s1,1024;
    xori $s0,$s1,1024;
    lui $s0,255;
    slti $s0,$s1,255;
    beq $s0,$s1,255;
    bne $s0,$s1,255;
    j 2;
    jal 255;
    jr $s0;
    jalr $s0;
```
