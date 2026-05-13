/** Tunable game parameters (difficulty, scoring, capacity). */
class GameConfig {

  /** Starting number of edges; must not exceed 6 (clamped in initialize). */
  int initialEdgeCount = 3;

  int maxMarbles = 100;
  int addPoints = 50;
  int subtractPoints = 25;
}
