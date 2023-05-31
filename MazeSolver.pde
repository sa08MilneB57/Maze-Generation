import java.util.TreeSet;

class MazeSolver{
  final float h_weight = 1f;
  Maze maze;
  Cell tgt;
  TreeSet<Token> priorities;//g is distance from start node, h is distance from end node. The sum of these is the f_cost
  MazeSolver(Maze _maze){
    maze = _maze;
    priorities = new TreeSet<Token>();
  }
  float hcost(Cell one, Cell two){ return abs(one.x - two.x) + abs(one.y - two.y);  }//manhattan distance between two cells
  //float hcost(Cell one, Cell two){ return dist(one.x,one.y,two.x,two.y);  }//euclidean distance between two cells
  
  void getTarget(){
    tgt = maze.grid[maze.end_cell];
  }
  
  class Token implements Comparable<Token>{
    Cell cell;// node
    float h;// h cost (distance to end)
    float g;// g cost (distance travelled from start)
    Token last;// previous node
    Token(Cell _cell, float h_cost,Token previous){
      cell = _cell;
      h = hcost(cell,tgt);
      last = previous;
      g = (previous != null)?previous.g + 1:0;
    }
    float f(){return h_weight*h + g;} //f cost
    
    public boolean equals(Token other){return this.cell == other.cell && this.f() == other.f();}
    
    @Override public int compareTo(Token other)
    {
      if (this.f() < other.f()){
        return -1;
      } else if (this.f() > other.f()){
        return  1;
      } else {
        if (this.h < other.h){
          return -1;
        } else if (this.h > other.h){
          return  1;
        } else {
          if (this.cell.y < other.cell.y){
            return -1;
          } else if (this.cell.y > other.cell.y){
            return  1;
          } else {
            if (this.cell.x < other.cell.x){
              return -1;
            } else if (this.cell.x > other.cell.x){
              return  1;
            } else {
              return 0;
            }                
          }
        }
      }
    }
  }  //end of Token
  
  Token startToken(){
    Cell start = maze.grid[maze.start_cell];
    float h_cost = hcost(start,tgt);
    return new Token(start,h_cost,null);
  }
  
  boolean step(){
    if(priorities.isEmpty()){//if queue is empty, start queue
      priorities.add(startToken());
      return false;
    }
    
    Token current = priorities.pollFirst();
    current.cell.visited = true;
    for(int n : maze.getExits(current.cell.x,current.cell.y)){
      Cell nextcell = maze.grid[n];
      if(nextcell.visited){continue;}
      float h_cost = hcost(nextcell,current.cell);
      priorities.add( new Token(nextcell,h_cost,current) );
    }    
    return priorities.first().cell == tgt;
  }
  
  void show(){
    if(priorities.isEmpty()){return;}
    float dx = (float)width / (float)(maze.cell_width);
    float dy = (float)height / (float)(maze.cell_height);
    float dcol = 1f/(priorities.size()-1);
    float col = 0;
    strokeWeight(4);
    for(Token current : priorities){
      //print(current.f()); print(" ");
      while(current.last != null){
        stroke(50*col,180*col,100*(1-col));
        float off = 0.25f + 0.5*col;
        float px = (current.last.cell.x + off)*dx;
        float py = (current.last.cell.y + off)*dy;
        float cx = (current.cell.x + off)*dx;
        float cy = (current.cell.y + off)*dy;
        line(px,py,cx,cy);
        current = current.last;
      }
      col += dcol;
    }
    //println();
  }
}
