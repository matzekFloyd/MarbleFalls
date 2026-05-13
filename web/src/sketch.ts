import type p5 from 'p5';
import { GameConfig } from './gameConfig';
import { Timer } from './timer';
import { Marble } from './marble';
import { Edge } from './edge';
import { lineCircle } from './collisions';

/** p5 instance-mode sketch (bundles cleanly; no global `setup` / `draw`). */
export function marbleFallsSketch(p: p5): void {
  let config: GameConfig;
  let timer: Timer;
  const marbles: Marble[] = [];
  const edges: Edge[] = [];
  let score = 0;

  function initialize(edgeCount: number): void {
    timer.start();
    score = 0;
    let n = edgeCount;
    if (n > 6) n = 6;
    for (let i = 0; i < n; i++) {
      const newE = new Edge(p);
      const offset = 100;
      const edgeLength = Math.floor(p.random(50, 200));
      const randSpeed = Math.floor(p.random(1, 10));
      newE.setEdgeX1(offset);
      newE.setEdgeX2(offset + edgeLength);
      newE.setEdgeY1(p.height / 2 + offset * i);
      newE.setEdgeY2(p.height / 2 + offset * i);
      newE.setSpeedX(randSpeed);
      if (i % 3 === 0) newE.collisionEdge = true;
      else newE.plusEdge = true;
      edges.push(newE);
    }
  }

  function trySpawnMarble(xMapped: number, yMapped: number): void {
    if (marbles.length <= config.maxMarbles) {
      const radius = 10;
      marbles.push(new Marble(p, xMapped, yMapped, radius));
    }
  }

  function spawnFromPointer(mx: number, my: number): void {
    const offset = 50;
    const yMaxSpawn = p.height / 2 - offset;
    if (my > yMaxSpawn) return;
    const x = p.constrain(mx, offset, p.width - offset);
    const y = p.constrain(my, offset, yMaxSpawn);
    trySpawnMarble(x, y);
  }

  function checkForDeadMarbles(): void {
    for (let i = marbles.length - 1; i >= 0; i--) {
      if (marbles[i].getOutOfBoundsCounter() === 0) marbles.splice(i, 1);
    }
  }

  function interval(): void {
    if (p.frameCount % 1000 === 0) {
      const randX1 = Math.floor(p.random(20, 300));
      const randX2 = randX1 + Math.floor(p.random(50, 200));
      const randY = Math.floor(p.random(500, 1100));
      const randSpeed = p.random(1, 10);
      const randType = Math.floor(p.random(0, 40));
      createHorizontalEdge(randX1, randX2, randY, randSpeed, randType);
    }
    if (p.frameCount % 2000 === 0) {
      const randY1 = Math.floor(p.random(20, 150));
      const randY2 = randY1 + Math.floor(p.random(50, 200));
      const randX = Math.floor(p.random(20, 200));
      createVerticalEdge(randX, randY1, randY2, p.random(1, 10), Math.floor(p.random(0, 50)));
    }
    if (p.frameCount % 2000 === 0) {
      const randY1 = Math.floor(p.random(20, 150));
      const randY2 = randY1 + Math.floor(p.random(50, 200));
      const randX = Math.floor(p.random(p.width - 200, p.width - 20));
      createVerticalEdge(randX, randY1, randY2, p.random(1, 10), Math.floor(p.random(0, 50)));
    }
  }

  function createHorizontalEdge(x1: number, x2: number, y: number, speed: number, type: number): void {
    if (type >= 0 && type <= 4) return;
    const newE = new Edge(p);
    newE.setEdgeX1(x1);
    newE.setEdgeX2(x2);
    newE.setEdgeY1(y);
    newE.setEdgeY2(y);
    newE.setSpeedX(speed);
    if (type >= 5 && type <= 19) newE.plusEdge = true;
    if (type >= 20 && type <= 29) newE.minusEdge = true;
    if (type >= 30 && type <= 40) newE.collisionEdge = true;
    edges.push(newE);
  }

  function createVerticalEdge(x: number, y1: number, y2: number, speed: number, type: number): void {
    if (type >= 0 && type <= 35) return;
    const newE = new Edge(p);
    newE.setEdgeX1(x);
    newE.setEdgeX2(x);
    newE.setEdgeY1(y1);
    newE.setEdgeY2(y2);
    newE.setSpeedY(speed);
    if (type >= 36 && type <= 40) newE.plusEdge = true;
    if (type >= 41 && type <= 45) newE.minusEdge = true;
    if (type >= 46 && type <= 50) newE.collisionEdge = true;
    edges.push(newE);
  }

  function move(): void {
    for (let i = 0; i < marbles.length; i++) marbles[i].move();
    for (let j = 0; j < edges.length; j++) edges[j].move();
  }

  function handleCollisions(): void {
    for (let i = 0; i < marbles.length; i++) {
      marbles[i].checkOutOfBounds();
      for (let j = 0; j < edges.length; j++) {
        try {
          marbles[i].hit = lineCircle(
            p,
            edges[j].getEdgeX1(),
            edges[j].getEdgeY1(),
            edges[j].getEdgeX2(),
            edges[j].getEdgeY2(),
            marbles[i].getX(),
            marbles[i].getY(),
            marbles[i].getRadius()
          );
          if (marbles.length > 0 && marbles[i].hit) {
            if (edges[j].getPlusEdge()) {
              score += config.addPoints;
              marbles.splice(i, 1);
              i--;
              break;
            } else if (edges[j].getMinusEdge()) {
              score -= config.subtractPoints;
              marbles.splice(i, 1);
              i--;
              break;
            } else if (edges[j].getCollisionEdge()) {
              marbles[i].setSpeedX(p.random(-2, -1));
              marbles[i].setSpeedY(p.random(-2, -1));
            }
          }
        } catch (err) {
          console.warn(err);
        }
      }
    }
  }

  function countMarbles(): number {
    return marbles.length;
  }

  function display(): void {
    p.textSize(16);
    p.fill(255);
    p.noStroke();
    p.text(String(score), p.width - 75, 50);
    p.text(`Marbles: ${countMarbles()}`, 50, p.height - 75);
    p.text(`max.: ${config.maxMarbles}`, 50, p.height - 50);
    p.text(
      `${p.nf(timer.hour(), 2)}:${p.nf(timer.minute(), 2)}:${p.nf(timer.second(), 2)}`,
      50,
      50
    );
    p.text('©mt151062', p.width - 150, p.height - 50);

    p.fill(255, 255, 255);
    p.stroke(255, 255, 255);
    p.strokeWeight(2);
    const offset = 5;
    p.line(offset, offset, p.width - offset, offset);
    p.line(p.width - offset, offset, p.width - offset, p.height - offset);
    p.line(p.width - offset, p.height - offset, offset, p.height - offset);
    p.line(offset, p.height - offset, offset, offset);
    p.strokeWeight(1);
    p.stroke(0, 0, 0);

    for (let i = 0; i < marbles.length; i++) marbles[i].display();
    for (let j = 0; j < edges.length; j++) edges[j].display();
  }

  p.setup = () => {
    config = new GameConfig();
    timer = new Timer(p);
    p.createCanvas(800, 1200).parent('game');
    p.frameRate(50);
    initialize(config.initialEdgeCount);
  };

  p.draw = () => {
    p.background(0);
    checkForDeadMarbles();
    interval();
    move();
    handleCollisions();
    display();
  };

  p.mousePressed = () => {
    spawnFromPointer(p.mouseX, p.mouseY);
  };
}
