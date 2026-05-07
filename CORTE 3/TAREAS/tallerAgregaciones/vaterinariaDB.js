// Crear base de datos
use empresaVeterinaria;

// Crear la colección e insertar datos
db.employee.insertMany([
  {
    firstname: "Sara",
    lastname: "Ferro",
    gender: "femenino",
    jobtitle: "Veterinaria",
    salary: 2500000
  },
  {
    firstname: "Santiago",
    lastname: "Echeverria",
    gender: "masculino",
    jobtitle: "Auxiliar de estética",
    salary: 1500000
  },
  {
    firstname: "Alisson",
    lastname: "Maturin",
    gender: "femenino",
    jobtitle: "Auxiliar de estética",
    salary: 1500000
  },
  {
    firstname: "Raul",
    lastname: "Suescun",
    gender: "masculino",
    jobtitle: "Veterinario",
    salary: 2500000
  },
  {
    firstname: "Valentina",
    lastname: "Martínez",
    gender: "femenino",
    jobtitle: "Recepcionista",
    salary: 1700000
  },
  {
    firstname: "Gustavo",
    lastname: "Fernández",
    gender: "masculino",
    jobtitle: "Auxiliar de estética",
    salary: 1500000
  },
  {
    firstname: "Sofía",
    lastname: "Díaz",
    gender: "femenino",
    jobtitle: "Veterinaria",
    salary: 2500000
  }
]);
db.employee.find().pretty();

// Ejercicio 1: Cantidad de empleados agrupados por género y ordenados de menor a mayor
db.employee.aggregate([
  {
    $group: {
      _id: "$gender",
      cantidadEmpleados: { $sum: 1 }
    }
  },
  {
    $sort: { cantidadEmpleados: 1 }
  }
]);

// Ejercicio 2: Cantidad de auxiliares de estética por género, orden ascendente por género
db.employee.aggregate([
  {
    $match: { jobtitle: "Auxiliar de estética" }
  },
  {
    $group: {
      _id: "$gender",
      cantidad: { $sum: 1 }
    }
  },
  {
    $sort: { _id: 1 }
  }
]);

// Ejercicio 3: Total de nómina por cargo, orden alfabético por cargo
db.employee.aggregate([
  {
    $group: {
      _id: "$jobtitle",
      totalNominas: { $sum: "$salary" }
    }
  },
  {
    $sort: { _id: 1 }
  }
]);

// Ejercicio 4: Total de nómina por cargo que supere 5 millones
db.employee.aggregate([
  {
    $group: {
      _id: "$jobtitle",
      totalNominas: { $sum: "$salary" }
    }
  },
  {
    $match: { totalNominas: { $gt: 5000000 } }
  }
]);