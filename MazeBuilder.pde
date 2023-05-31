import java.util.ArrayDeque;

class MazeBuilder{
  Maze maze;
  color path_color = color(0,100,50);
  color border_color = color(0,50,0);
  color body_color = color(20,100,10);
  int x,y;
  ArrayDeque<Integer> pathStack;
  MazeBuilder(Maze _maze){
    maze=_maze;
    x=0;y=0;
    maze.markVisited(0,0);
    pathStack = new ArrayDeque<Integer>();
    pathStack.add(0);
  }
  
  boolean step(){
    ArrayList<Integer> neighbors = maze.getNeighbors(x,y);
    while(neighbors.size() > 0){
      int choice = neighbors.remove((int)random(neighbors.size()));
      if(!maze.grid[choice].visited){
        int next_x = choice % maze.cell_width;
        int next_y = (choice-next_x) / maze.cell_width;
        maze.markVisited(next_x,next_y);
        maze.removeWallBetween(x,y,next_x,next_y);
        x = next_x;
        y = next_y;
        pathStack.addLast(choice);
        return false;
      }
    }
    if (pathStack.size()>0){
      int next = pathStack.pollLast();
      x = next % maze.cell_width;
      y = (next-x) / maze.cell_width;
      return false;
      
    }
    return true;
    
  }
  
  void show(){
    float dx = (float)width / (float)(maze.cell_width);
    float dy = (float)height / (float)(maze.cell_height);
    int lastPath = -1;
    pushStyle();
      stroke(path_color);
      strokeWeight(2);
      for(int path : pathStack){
        if (lastPath != -1){
          int px = path % maze.cell_width;
          int py = (path-px) / maze.cell_width;
          int lpx = lastPath % maze.cell_width;
          int lpy = (lastPath-lpx) / maze.cell_width;
          line(dx*(px+0.5),dy*(py+0.5),dx*(lpx+0.5),dy*(lpy+0.5));
        }
        lastPath = path;
      }
    popStyle();
      
    
    pushStyle();
      fill(body_color);
      stroke(border_color);
      strokeWeight(2);
      circle(dx*(x + 0.5f),dy*(y+0.5f),min(dx,dy)/4f);
    popStyle();
  }
}
