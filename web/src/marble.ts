import type p5 from 'p5';

export class Marble {
  private xPos: number;
  private yPos: number;
  private xDir = 1;
  private yDir = 1;
  private speedX = 0;
  private speedY = 5;
  hit = false;
  private outOfBoundsCounter = 3;
  readonly radius: number;

  constructor(
    private readonly p: p5,
    xPos: number,
    yPos: number,
    radius: number
  ) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
  }

  getX(): number {
    return this.xPos;
  }

  getY(): number {
    return this.yPos;
  }

  getRadius(): number {
    return this.radius;
  }

  getSpeedX(): number {
    return this.speedX;
  }

  setSpeedX(s: number): void {
    this.speedX *= s;
  }

  getSpeedY(): number {
    return this.speedY;
  }

  setSpeedY(s: number): void {
    this.speedY *= s;
  }

  getOutOfBoundsCounter(): number {
    return this.outOfBoundsCounter;
  }

  move(): void {
    this.xPos += this.speedX * this.xDir;
    this.yPos += this.speedY * this.yDir;
  }

  display(): void {
    const { p } = this;
    if (this.outOfBoundsCounter === 0) p.fill(255, 255, 255, 255);
    else if (this.outOfBoundsCounter === 1) p.fill(255, 255, 255, 170);
    else if (this.outOfBoundsCounter === 2) p.fill(255, 255, 255, 85);
    else p.fill(255, 255, 255, 255);
    p.circle(this.xPos, this.yPos, this.radius * 2);
    p.fill(255, 255, 255);
  }

  checkOutOfBounds(): boolean {
    const { p } = this;
    const w = p.width;
    const h = p.height;
    const r = this.radius;

    if (this.xPos + r > w) {
      this.xPos = w - r;
      this.xDir *= -1;
      this.outOfBoundsCounter -= 1;
    } else if (this.xPos <= 0) {
      this.xPos = r;
      this.xDir *= -1;
      this.outOfBoundsCounter -= 1;
    }

    if (this.yPos + r > h) {
      this.yPos = h - r;
      this.yDir *= -1;
      this.speedX = p.random(-5, 5);
      this.outOfBoundsCounter -= 1;
    } else if (this.yPos <= 0) {
      this.yPos = r;
      this.yDir *= -1;
      this.speedY = p.random(-5, 5);
      this.outOfBoundsCounter -= 1;
    }
    return false;
  }
}
