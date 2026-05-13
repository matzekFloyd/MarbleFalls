import type p5 from 'p5';

export function lineCircle(
  p: p5,
  x1: number,
  y1: number,
  x2: number,
  y2: number,
  cx: number,
  cy: number,
  r: number
): boolean {
  if (pointCircle(x1, y1, cx, cy, r) || pointCircle(x2, y2, cx, cy, r)) return true;

  const distX = x1 - x2;
  const distY = y1 - y2;
  const lenSq = distX * distX + distY * distY;
  if (lenSq < 1e-10) return false;

  const dot = ((cx - x1) * (x2 - x1) + (cy - y1) * (y2 - y1)) / lenSq;
  const closestX = x1 + dot * (x2 - x1);
  const closestY = y1 + dot * (y2 - y1);

  if (!linePoint(p, x1, y1, x2, y2, closestX, closestY)) return false;

  const ddx = closestX - cx;
  const ddy = closestY - cy;
  return Math.sqrt(ddx * ddx + ddy * ddy) <= r;
}

export function pointCircle(px: number, py: number, cx: number, cy: number, r: number): boolean {
  const distX = px - cx;
  const distY = py - cy;
  return Math.sqrt(distX * distX + distY * distY) <= r;
}

export function linePoint(
  p: p5,
  x1: number,
  y1: number,
  x2: number,
  y2: number,
  px: number,
  py: number
): boolean {
  const d1 = p.dist(px, py, x1, y1);
  const d2 = p.dist(px, py, x2, y2);
  const lineLen = p.dist(x1, y1, x2, y2);
  const buffer = 0.1;
  return d1 + d2 >= lineLen - buffer && d1 + d2 <= lineLen + buffer;
}
