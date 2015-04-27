.data
.text
SquareMultiply:
L0:
L2:
L4:
add  $3,  $1,  $2
add  $3,  $1,  $2
add  $3,  $1,  $2
add  $2,  $1,  1
j  L4
L5:
add  $3,  $1,  $2
add  $2,  $1,  1
j  L2
L3:
add  $2,  $1,  1
j  L0
L1:
MakeSquareInt:
L6:
add  $2,  $1,  0
add  $2,  $1,  1
add  $2,  $1,  2
add  $2,  $1,  3
add  $2,  $1,  4
add  $2,  $1,  1
j  L6
L7:
PrintMatrixI:
L8:
L10:
add  $3,  $1,  $2
add  $2,  $1,  1
j  L10
L11:
add  $2,  $1,  1
j  L8
L9:
main:
callr, matrix_1#main, MakeSquareInt, 1, 2, 3, 4, 5
callr, matrix_2#main, MakeSquareInt, 6, 7, 8, 9, 10
callr, matrix_C#main, SquareMultiply, matrix_1#main, matrix_2#main
#END:
jr $ra
