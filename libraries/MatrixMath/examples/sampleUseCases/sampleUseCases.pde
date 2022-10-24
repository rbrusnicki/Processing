import pallav.Matrix.*;
//Demonstrating use of some of the static Methods of library

float[][] array1={{2,1},{5,3}};  //sample array
float[][] array2={{4,7},{2,6}};
float[][] array3={{1},{2}};
float[][] array4={{1,2}};

float[][] add = Matrix.add(array1,array2);
float[][] transpose = Matrix.transpose(array1);
float determinant = Matrix.determinant(array1);
float[][] inverse = Matrix.inverse(array1);

Matrix.print(array1);
Matrix.print(array2);
Matrix.print(array3);
Matrix.print(array4);


Matrix mat1 = Matrix.array(array1);
Matrix mat2 = Matrix.array(array2);
Matrix mat3 = Matrix.array(array3);
Matrix mat4 = Matrix.array(array4);

Matrix mat5 = Matrix.Multiply(mat1, mat3); // deu certo


//Matrix mat6 = Matrix.Multiply(mat1, mat4);


Matrix.print(mat5);
