# Exercise 01 — Show me your DB

The assignment allows pgAdmin, Postico, DBeaver, or another database GUI. This README records a repeatable connection setup.

## Recommended option: DBeaver

Install DBeaver Community on the Mac, then create a PostgreSQL connection with:

- Host: `localhost`
- Port: `5432`
- Database: `piscineds`
- Username: your exact 42 login (the `PGUSER` used for Exercise 00)
- Password: `mysecretpassword`

If DBeaver asks to download the PostgreSQL driver, allow it while online.

## Verify the GUI

1. Connect to the database.
2. Expand `piscineds` → `Schemas` → `public` → `Tables`.
3. Confirm you can browse tables and view/edit records by their IDs once tables have been created in later exercises.

## Important

Exercise 01's PDF does not specify a required submission filename. This README is supplementary documentation, not a substitute for demonstrating the GUI during evaluation. The evaluator's machine may differ from your Mac, so confirm the GUI is available or can be installed at 42 Tokyo.
