# NutriFit

## Features

* Ability to track and create your own personal workouts and personal records.
* Scan Barcodes to get macros on food items.

## Backend

### Setup Backend Server

#### Environment Variables

Before setting up the server, you must set the correct environment variables for the backend to run correctly.

First cd in the backend directory.

```bash
cd backend/
```

Then create the environment file by running the following command.

```bash
touch .env
```

Here are all the environment variables the backend server uses.
| Variable      | Description |
| ----------- | ----------- |
| *Port* (Optional)      | Port the Server is ran on. Default is 3000.       |
| **USDA_API_KEY (SOON TO BE REMOVED)**   | [USDA FoodCentral Data API](https://fdc.nal.usda.gov/api-guide.html) Key        |

#### Step 1 - Installing Node & Yarn

to setup the backend server you need [node](https://nodejs.org/en), to install node on Windows and Linux systems you can you use [Homebrew](https://brew.sh/).

After you installed Homebrew, you can run the following command to install node.

```bash
brew install node
```

Once you installed node, we can install our package manager [yarn](https://yarnpkg.com/), to do so you can run the following command.

```bash
npm install --global yarn
```

#### Step 2 - Installing All Node Packages

Now that you have the package manager installed, head to the backend directory.

```bash
cd backend/
```

Then run the following command to download all the packages necessary.

```bash
yarn
```

#### Step 3 - Starting the Server

Once you installed all the packages you can start the backend(server) but run the following command.

```bash
yarn start
```
