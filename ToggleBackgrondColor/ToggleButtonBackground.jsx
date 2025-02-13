import React, { useState } from "react";
import "../style.css";

const ToggleButtonBackground = () => {
  const [backgroundColor, setBackgroundColor] = useState("#FBFFE4");
  const [textColor, setTextColor] = useState("#1b1b1b");
  const [buttonStyle, setButtonStyle] = useState("#FBFFE4");

  const handleClick = () => {
    setBackgroundColor(backgroundColor === "#FBFFE4" ? "#1b1b1b" : "#FBFFE4");
    setTextColor(textColor === "#1b1b1b" ? "#ffa31a" : "#1b1b1b");
    setButtonStyle(buttonStyle === "#FBFFE4" ? "1b1b1b" : "#FBFFE4");
  };

  return (
    <div style={{ backgroundColor, color: textColor }}>
      <button
        onClick={handleClick}
        style={{
          buttonStyle,
          color: textColor,
          border: `2px solid ${textColor}`,
        }}
      >
        {backgroundColor === "#1b1b1b" ? "Black Theme" : "White Theme"}
      </button>
      <section className="content">
        <h1>
          Welcome To A <br />
          Real World...
        </h1>
      </section>
    </div>
  );
};

export default ToggleButtonBackground;
