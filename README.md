# Fetch Rewards Points API

## Description

Web service that accepts HTTP requests and returns responses in JSON format.

## Assumptions

Assuming that users, payers and their relationships already exist in database; and that authentication and authorization has been already handled by the system, this api only deals with an abstraction of the points related transactions.
All `spend` transactions will be debited with the total amount of points available from the payers, even if the amount requested is greater than the available points.

## Usage

1. Clone this repository to create a local copy in your computer.

```
git clone git@github.com:MarielJHoepelman/fetch_rewards.git
```

2.  Change directory to the project folder.

```
cd fetch_rewards
```

3. Run bundle install to install all dependencies.

```
bundle install
```

4. Run the database migrations.

```
bundle exec rails db:migrate
```

5. Run the seeds file.

```
bundle exec rails db:seed
```

6. Start the local server and go to https address (e.g http://localhost:3000/)

```
bundle exec rails s
```

7. For balance run:

```
curl -X GET http://localhost:3000/points/balance
```

8. For spending points run:

```
curl -d "points=5000" -X POST http://localhost:3000/points/spend
```

9. To add transactions to the database run:

```
curl -d "payer=DANNON&points=1000&timestamp=2020-11-02T14:00:00Z" -X POST http://localhost:3000/points/add
```
