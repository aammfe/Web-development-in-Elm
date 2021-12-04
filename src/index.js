import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

var app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: 10
});

app.ports.output.subscribe((obj)=> {
  console.log(obj)
});

setTimeout(
  () => app.ports.incoming.send([{score: 1, total: 2}]),
  1000
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
