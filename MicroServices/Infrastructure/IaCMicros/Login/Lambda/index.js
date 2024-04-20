const { MongoClient } = require('mongodb');


async function connectToMongoDB(){


     // name of the environmental variable
     const mongoPassword = process.env.MongoPassword;
     // füpr den DBUser
      const uri = `mongodb+srv://ThesisAI:${mongoPassword}@clusterregister.zotgyzf.mongodb.net/?retryWrites=true&w=majority`
      const client = new MongoClient(uri);
 
      try {
          // Connect to the MongoDB cluster
          await client.connect();
          console.log("Connection from client was successful")
           
          // returning clients for 
          return client;
  
      } catch (e) {
          throw e;
      }
 }

 