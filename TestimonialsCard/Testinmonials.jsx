import React, { useState } from "react";
import "../style.css";

const Testimonials = () => {
  const [currentIndex, setCurrentIndex] = useState(0);

  const handlePrevClick = () => {
    setCurrentIndex(
      (currentIndex + Testimonials.length - 1) % Testimonials.length
    );
  };
  const handleNextClick = () => {
    setCurrentIndex(
      (currentIndex + Testimonials.length + 1) % Testimonials.length
    );
  };

  const Testimonials = [
    {
      quote:
        "The service exceeded my expectations in every way. I couldn't be happier with the outcome!",
      author: "Sarah Johnson, Marketing Specialist",
    },
    {
      quote:
        "I've tried other options before, but this was a game-changer. Highly recommended!",
      author: "James Wilson, Product Manager",
    },
    {
      quote:
        "Exceptional quality and top-notch support. I'll definitely be coming back for more.",
      author: "Maria Lopez, Business Owner",
    },
  ];

  return (
    <div className="testimonials">
      <div className="testimonials-quote">
        {Testimonials[currentIndex].quote}
      </div>

      <div className="testimonials-author">
        -{Testimonials[currentIndex].author}
      </div>
      <div className="testimonials-nav">
        <button onClick={handlePrevClick}>prev</button>
        <button onClick={handleNextClick}>next</button>
      </div>
    </div>
  );
};

export default Testimonials;
