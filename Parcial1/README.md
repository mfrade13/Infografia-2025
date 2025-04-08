# Wordle in Lua

This project is a simple implementation of the popular Wordle game using Lua and the Solar2D framework. The game randomly selects a word by fetching it from a small Node.js API and challenges the player to guess it within a set number of attempts.

## Game Overview

Wordle is a puzzle game where the player must guess a hidden word within a limited number of attempts. With each guess, the game provides feedback to help the player narrow down the correct letters and positions.

## Project Details

- **This implementation was developed as a class project for "Infographic" class at UPB Cochabamba.**
- **Language & Framework:** Implemented in Lua and built using the Solar2D framework.
- **API Integration:** The game retrieves the target word using a very simple API built in Node.js.

## Getting Started

### Prerequisites

- **Solar2D:** Make sure that Solar2D is installed on your system to run Lua-based projects.
- **Node.js:** Node.js must be installed to run the API server that provides the game word.

### Running the Game

1. **Start the API:**
   - Open a terminal in the API directory and run:
     ```bash
     node index.js
     ```
   - This will start the server that supplies the word for the game.

2. **Run the Game:**
   - Navigate to the project directory where the `main.lua` file is located.
   - Open the project using Solar2D. The game will start, and it will fetch the word from the API.

## Project Structure

- **NodeAPI:** Word extraction Backend
- **WordleSolar2d:** Implementation of the game in Lua

