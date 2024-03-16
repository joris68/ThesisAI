const AWS = require('aws-sdk');
const secretsManager = new AWS.SecretsManager();
const { MongoClient } = require('mongodb');

// Function to retrieve secret
async function retrieveSecret(secretName, secretsManager) {
    let secret, decodedBinarySecret;
    const data = await secretsManager.getSecretValue({SecretId: secretName}).promise();

    // Check if the secret is stored as a string or binary
    if ('SecretString' in data) {
        secret = data.SecretString;
    } else {
        // Note: Use Buffer.from instead of new Buffer to avoid deprecation warnings
        decodedBinarySecret = Buffer.from(data.SecretBinary, 'base64').toString('ascii');
    }

    return secret ? secret : decodedBinarySecret;
}


async function connectToData(){

     const uri = `mongodb+srv://ThesisAI:${secretObj}@clusterregister.zotgyzf.mongodb.net/?retryWrites=true&w=majority`
     const client = new MongoClient(uri);
     Console.log()

     try {
         // Connect to the MongoDB cluster
         await client.connect();
          
         // returning clients for 
         return client;
 
     } catch (e) {
         console.error(e);
     } finally {
         await client.close();
     }

}

exports.handler = async (event) => {
    const secretName = "yourSecretName"; // Replace with your actual secret name

    try {
        const secret = await retrieveSecret(secretName, secretsManager);
        const secretObj = secret ? JSON.parse(secret) : null;
        // Use secretObj as needed, for example, access properties like secretObj.username

    } catch (err) {
        console.error(err);
        return {
            statusCode: 500,
            body: JSON.stringify({
                error: "Failed to retrieve secret"
            }),
        };
    }

    /**
* Connection URI. Update <username>, <password>, and <your-cluster-url> to reflect your cluster.
* See https://docs.mongodb.com/ecosystem/drivers/node/ for more details
*/
const uri = `mongodb+srv://ThesisAI:${secretObj}@clusterregister.zotgyzf.mongodb.net/?retryWrites=true&w=majority` 
const client = new MongoClient(uri);

try {
     await client.connect();
 
     await listDatabases(client);
 
} catch (e) {
     console.error(e);
     return {
          statusCode: 400,
          body: JSON.stringify({
               error: "Failed"
          })
     }
}finally{
     await client.close();
}


};
