import type p5 from 'p5';

export class Timer {
  private startTime = 0;
  private stopTime = 0;
  private running = false;

  constructor(private readonly p: p5) {}

  start(): void {
    this.startTime = this.p.millis();
    this.running = true;
  }

  stop(): void {
    this.stopTime = this.p.millis();
    this.running = false;
  }

  getElapsedTime(): number {
    if (this.running) return this.p.millis() - this.startTime;
    return this.stopTime - this.startTime;
  }

  second(): number {
    return Math.floor(this.getElapsedTime() / 1000) % 60;
  }

  minute(): number {
    return Math.floor(this.getElapsedTime() / (1000 * 60)) % 60;
  }

  hour(): number {
    return Math.floor(this.getElapsedTime() / (1000 * 60 * 60)) % 24;
  }
}
