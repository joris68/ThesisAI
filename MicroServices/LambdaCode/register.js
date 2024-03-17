const AWS = require('aws-sdk');
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
         console.error(e);
         throw e;
     }
}

async function registerUserToDB(client, document) {
    try {
        await client.db("UsersThesisAI").collection("Users").insertOne(document);
    } catch (e) {
        console.log("Error inserting document into MongoDB: " + e);
        throw e; 
    }
}

async function extractUserData(event){
 // extract user data to be added
 return "to be added"
}

exports.handler = async (event) => {
    let client;
    try {
        client = await connectToMongoDB();
        const userData = await extractUserData(event); 
        await registerUserToDB(client, userData);

        return {
            statusCode: 200,
            body: JSON.stringify({
                success: "Successfully registered user",
            }),
        };
    } catch (err) {
        console.error(err);
        return {
            statusCode: err.statusCode || 500,
            body: JSON.stringify({
                error: err.message || "An error occurred",
            }),
        };
    } finally {
        if (client) {
            await client.close();
        }
    }
};

