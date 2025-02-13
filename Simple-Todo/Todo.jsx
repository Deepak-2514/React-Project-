import React, { useState } from "react";
import "../style.css";

const Todo = () => {
  const [todos, setTodo] = useState([]);
  const [input, setInput] = useState("");

  const handelSubmit = () => {
    if (input.trim() === "") return;
    setTodo(() => [
      ...todos,
      {
        text: input,
        id: Date.now(),
      },
    ]);
    setInput("");
  };

  const removeTodo = (id) => {
    setTodo(todos.filter((t) => t.id !== id));
  };

  return (
    <div className="container">
      <h1 className="header">Todo list </h1>
      <input
        type="text"
        value={input}
        placeholder="Enter Todo"
        onChange={(e) => setInput(e.target.value)}
      />
      <button onClick={handelSubmit}>Submit</button>
      <ul>
        {todos.map(({ text, id }) => (
          <li key={id} className="todo">
            <span>{text}</span>
            <button className="close" onClick={() => removeTodo(id)}>
              X
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default Todo;
