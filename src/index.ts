import express, { Request, Response } from "express";

const expressApp = express()

expressApp.get("/", (req: Request, res: Response) => {
    res.send("Hello World")
})

expressApp.listen(3000, () => {
    console.log("Server running on port 3000")
})