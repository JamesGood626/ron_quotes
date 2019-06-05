import React, { useState } from "react";
import "./App.css";

const ANY = "ANY";
const SMALL = "SMALL";
const MEDIUM = "MEDIUM";
const LARGE = "LARGE";

function App() {
  const [quoteLength, setQuoteLength] = useState(null);
  const [quote, setQuote] = useState("");
  const [stars, setStars] = useState(1);

  const getWisdom = () => {
    switch (quoteLength) {
      case ANY:
        fetchQuote("/quote");
        break;
      case SMALL:
        fetchQuote("/quote/small");
        break;
      case MEDIUM:
        fetchQuote("/quote/medium");
        break;
      case LARGE:
        fetchQuote("/quote/large");
        break;
      default:
        fetchQuote("/quote");
    }
  };

  const fetchQuote = path => {
    const request = new XMLHttpRequest();
    request.addEventListener("load", gotWisdom);
    request.open("GET", `http://localhost:4000/${path}`);
    request.send();
  };

  function gotWisdom() {
    console.log("You've got wisdom: ", this);
    setQuote(JSON.parse(this.responseText).data);
  }

  // Quote retrieved from API will be:
  // 4 words or less if small
  // 5 to 12 words if medium
  // 13 words or longer if large
  const handleSetQuoteLength = e => {
    const { value } = e.target;
    switch (value) {
      case ANY:
        setQuoteLength(ANY);
        break;
      case SMALL:
        setQuoteLength(SMALL);
        break;
      case MEDIUM:
        setQuoteLength(MEDIUM);
        break;
      case LARGE:
        setQuoteLength(LARGE);
        break;
      default:
        return;
    }
  };

  const handleStarClick = e => {
    const { id } = e.target;
    switch (id) {
      case "one-star":
        setStars(1);
        break;
      case "two-star":
        setStars(2);
        break;
      case "three-star":
        setStars(3);
        break;
      case "four-star":
        setStars(4);
        break;
      case "five-star":
        setStars(5);
        break;
      default:
        return;
    }
  };

  const fillStar = num => (num <= stars ? `star filled` : `star`);

  return (
    <div className="App">
      <div id="quote-container">
        <p>{quote}</p>
        <div id="star-container" onClick={handleStarClick}>
          <div id="one-star" className={fillStar(1)} />
          <div id="two-star" className={fillStar(2)} />
          <div id="three-star" className={fillStar(3)} />
          <div id="four-star" className={fillStar(4)} />
          <div id="five-star" className={fillStar(5)} />
        </div>
      </div>
      <div id="quote-options_btn-container">
        <select onChange={handleSetQuoteLength}>
          <option value="ANY">Any</option>
          <option value="SMALL">Small</option>
          <option value="MEDIUM">Medium</option>
          <option value="LARGE">Large</option>
        </select>
        <button onClick={getWisdom}>Get Wisdom!</button>
      </div>
    </div>
  );
}

export default App;
