import type p5 from 'p5';

export class Edge {
  private eX1 = 0;
  private eY1 = 0;
  private eX2 = 0;
  private eY2 = 0;
  private xDir = 1;
  private yDir = 1;
  private speedX = 0;
  private speedY = 0;
  plusEdge = false;
  minusEdge = false;
  collisionEdge = false;

  constructor(private readonly p: p5) {}

  setEdgeX1(x: number): void {
    this.eX1 = x;
  }
  getEdgeX1(): number {
    return this.eX1;
  }
  setEdgeX2(x: number): void {
    this.eX2 = x;
  }
  getEdgeX2(): number {
    return this.eX2;
  }
  setEdgeY1(y: number): void {
    this.eY1 = y;
  }
  getEdgeY1(): number {
    return this.eY1;
  }
  setEdgeY2(y: number): void {
    this.eY2 = y;
  }
  getEdgeY2(): number {
    return this.eY2;
  }

  getPlusEdge(): boolean {
    return this.plusEdge;
  }
  getMinusEdge(): boolean {
    return this.minusEdge;
  }
  getCollisionEdge(): boolean {
    return this.collisionEdge;
  }

  getSpeedX(): number {
    return this.speedX;
  }
  setSpeedX(s: number): void {
    this.speedX = s;
  }
  getSpeedY(): number {
    return this.speedY;
  }
  setSpeedY(s: number): void {
    this.speedY = s;
  }

  move(): void {
    const { p } = this;
    this.eX1 += this.speedX * this.xDir;
    this.eX2 += this.speedX * this.xDir;
    this.eY1 += this.speedY * this.yDir;
    this.eY2 += this.speedY * this.yDir;

    if (this.eX2 >= p.width) this.xDir *= -1;
    if (this.eX1 <= 0) this.xDir *= -1;
    if (this.eY2 >= p.height || this.eY1 >= p.height) this.yDir *= -1;
    if (this.eY1 <= 0 || this.eY2 <= 0) this.yDir *= -1;
  }

  display(): void {
    const { p } = this;
    if (this.plusEdge) p.stroke(0, 255, 0);
    else if (this.minusEdge) p.stroke(255, 0, 0);
    else if (this.collisionEdge) p.stroke(0, 0, 255);
    p.strokeWeight(5);
    p.line(this.eX1, this.eY1, this.eX2, this.eY2);
    p.strokeWeight(1);
    p.stroke(0, 0, 0);
  }
}
