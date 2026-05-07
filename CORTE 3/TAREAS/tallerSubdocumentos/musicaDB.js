// Crear base de datos
use musicaDB;

// 1,2,3. Insertar 5 bandas, 2 albums por banda y 5 canciones por album

db.bands.insertMany([
  {
    name: "Bon Jovi",
    country: "USA",
    url: "https://www.bonjovi.com",
    albums: [
      {
        title: "Slippery When Wet",
        dateCreated: new Date("1986-08-18"),
        songs: [
          { titleSong: "Livio' on a Prayer", author: "Bon Jovi", duration: 242 },
          { titleSong: "You Give Love a Bad Name", author: "Bon Jovi", duration: 203 },
          { titleSong: "Wanted Dead or Alive", author: "Bon Jovi", duration: 248 },
          { titleSong: "Never Say Goodbye", author: "Bon Jovi", duration: 288 },
          { titleSong: "Social Disease", author: "Bon Jovi", duration: 252 }
        ]
      },
      {
        title: "New Jersey",
        dateCreated: new Date("1988-09-19"),
        songs: [
          { titleSong: "Bad Medicine", author: "Bon Jovi", duration: 315 },
          { titleSong: "Born to Be My Baby", author: "Bon Jovi", duration: 298 },
          { titleSong: "I'll Be There for You", author: "Bon Jovi", duration: 324 },
          { titleSong: "Lay Your Hands on Me", author: "Bon Jovi", duration: 356 },
          { titleSong: "Blood on Blood", author: "Bon Jovi", duration: 366 }
        ]
      }
    ]
  },
  {
    name: "The Beatles",
    country: "UK",
    url: "https://www.thebeatles.com",
    albums: [
      {
        title: "Abbey Road",
        dateCreated: new Date("1969-09-26"),
        songs: [
          { titleSong: "Come Together", author: "Lennon-McCartney", duration: 259 },
          { titleSong: "Something", author: "George Harrison", duration: 183 },
          { titleSong: "Maxwell's Silver Hammer", author: "Lennon-McCartney", duration: 207 },
          { titleSong: "Oh! Darling", author: "Lennon-McCartney", duration: 206 },
          { titleSong: "Here Comes the Sun", author: "George Harrison", duration: 185 }
        ]
      },
      {
        title: "Sgt. Pepper's Lonely Hearts Club Band",
        dateCreated: new Date("1967-06-01"),
        songs: [
          { titleSong: "Sgt. Pepper's Lonely Hearts Club Band", author: "Lennon-McCartney", duration: 122 },
          { titleSong: "With a Little Help from My Friends", author: "Lennon-McCartney", duration: 164 },
          { titleSong: "Lucy in the Sky with Diamonds", author: "Lennon-McCartney", duration: 208 },
          { titleSong: "Getting Better", author: "Lennon-McCartney", duration: 167 },
          { titleSong: "A Day in the Life", author: "Lennon-McCartney", duration: 335 }
        ]
      }
    ]
  },
  {
    name: "Queen",
    country: "UK",
    url: "https://www.queenonline.com",
    albums: [
      {
        title: "A Night at the Opera",
        dateCreated: new Date("1975-11-21"),
        songs: [
          { titleSong: "Bohemian Rhapsody", author: "Freddie Mercury", duration: 355 },
          { titleSong: "You're My Best Friend", author: "John Deacon", duration: 176 },
          { titleSong: "Love of My Life", author: "Freddie Mercury", duration: 219 },
          { titleSong: "'39", author: "Brian May", duration: 188 },
          { titleSong: "Seaside Rendezvous", author: "Freddie Mercury", duration: 134 }
        ]
      },
      {
        title: "News of the World",
        dateCreated: new Date("1977-10-28"),
        songs: [
          { titleSong: "We Will Rock You", author: "Brian May", duration: 122 },
          { titleSong: "We Are the Champions", author: "Freddie Mercury", duration: 179 },
          { titleSong: "Spread Your Wings", author: "John Deacon", duration: 272 },
          { titleSong: "It's Late", author: "Brian May", duration: 372 },
          { titleSong: "My Melancholy Blues", author: "Freddie Mercury", duration: 209 }
        ]
      }
    ]
  },
  {
    name: "Metallica",
    country: "USA",
    url: "https://www.metallica.com",
    albums: [
      {
        title: "Master of Puppets",
        dateCreated: new Date("1986-03-03"),
        songs: [
          { titleSong: "Battery", author: "Metallica", duration: 312 },
          { titleSong: "Master of Puppets", author: "Metallica", duration: 515 },
          { titleSong: "The Thing That Should Not Be", author: "Metallica", duration: 397 },
          { titleSong: "Welcome Home (Sanitarium)", author: "Metallica", duration: 387 },
          { titleSong: "Disposable Heroes", author: "Metallica", duration: 497 }
        ]
      },
      {
        title: "Ride the Lightning",
        dateCreated: new Date("1984-07-27"),
        songs: [
          { titleSong: "Fight Fire with Fire", author: "Metallica", duration: 284 },
          { titleSong: "Ride the Lightning", author: "Metallica", duration: 399 },
          { titleSong: "For Whom the Bell Tolls", author: "Metallica", duration: 309 },
          { titleSong: "Fade to Black", author: "Metallica", duration: 416 },
          { titleSong: "Creeping Death", author: "Metallica", duration: 396 }
        ]
      }
    ]
  },
  {
    name: "Adele",
    country: "UK",
    url: "https://www.adele.com",
    albums: [
      {
        title: "21",
        dateCreated: new Date("2011-01-24"),
        songs: [
          { titleSong: "Rolling in the Deep", author: "Adele Adkins", duration: 228 },
          { titleSong: "Rumour Has It", author: "Adele Adkins", duration: 223 },
          { titleSong: "Someone Like You", author: "Adele Adkins", duration: 285 },
          { titleSong: "Set Fire to the Rain", author: "Adele Adkins", duration: 242 },
          { titleSong: "Don't You Remember", author: "Adele Adkins", duration: 243 }
        ]
      },
      {
        title: "25",
        dateCreated: new Date("2015-11-20"),
        songs: [
          { titleSong: "Hello", author: "Adele Adkins", duration: 295 },
          { titleSong: "Send My Love (To Your New Lover)", author: "Adele Adkins", duration: 223 },
          { titleSong: "When We Were Young", author: "Adele Adkins", duration: 290 },
          { titleSong: "Water Under the Bridge", author: "Adele Adkins", duration: 241 },
          { titleSong: "Million Years Ago", author: "Adele Adkins", duration: 227 }
        ]
      }
    ]
  }
]);

//consulta cada banda con su discografía relacionada
db.bands.find().pretty();

// 5. Borrar un campo del subdocumento albums (campo 'dateCreated' del álbum 'Slippery When Wet' de Bon Jovi)
db.bands.updateOne(
  { name: "Bon Jovi", "albums.title": "Slippery When Wet" },
  { $unset: { "albums.$.dateCreated": "" } }
);

db.bands.findOne({ name: "Bon Jovi" });

// 6: Borrar todo el subdocumento songs de uno de los albums de una banda (Eliminando el arreglo 'songs' del álbum '21' de Adele)
db.bands.updateOne(
  { name: "Adele", "albums.title": "21" },
  { $unset: { "albums.$.songs": "" } }
);

//Verificación: El álbum '21' ya no tiene el subdocumento songs
db.bands.findOne({ name: "Adele" });