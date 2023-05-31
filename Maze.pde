class Maze{
  color cell_color = color(255, 255, 95);
  color visited_color = color(105,45,20);
  color wall_color = color(10,8,57);
  int cell_width,cell_height;
  int start_cell,end_cell;
  Cell[] grid;
  Maze(int w, int h){
    cell_width = w;
    cell_height = h;
    start_cell = -1;
    end_cell = -1;
    grid = new Cell[cell_width * cell_height];
    for (int j=0; j<h; j++){
      for (int i=0; i<w; i++){
        grid[index(i,j)] = new Cell(i,j,15);
      }  
    }
  }
  
  int index(int i, int j){
    if(i<0 || i>=cell_width || j<0 || j>=cell_height){return -1;}
    return i + cell_width*j;
  }
  
  ArrayList<Integer> getNeighbors(int x, int y){
    //returns indexes of ALL orthogonal neighboring cells (cells over edge not returned, hence the ArrayList for flexible length)
    int u = index(x,y-1);
    int r = index(x+1,y);
    int d = index(x,y+1);
    int l = index(x-1,y);
    ArrayList<Integer> neighbors = new ArrayList<Integer>();
    if(u!=-1){neighbors.add(u);}
    if(r!=-1){neighbors.add(r);}
    if(d!=-1){neighbors.add(d);}
    if(l!=-1){neighbors.add(l);}
    return neighbors;
  }
  
  ArrayList<Integer> getExits(int x, int y){
    //returns indexes of neighboring cells where no wall blocks the path
    int c = index(x,y);
    int u = index(x,y-1);
    int r = index(x+1,y);
    int d = index(x,y+1);
    int l = index(x-1,y);
    ArrayList<Integer> exits = new ArrayList<Integer>();
    if(u!=-1 && ((grid[c].walls & 1) == 0)){exits.add(u);}
    if(r!=-1 && ((grid[c].walls & 2) == 0)){exits.add(r);}
    if(d!=-1 && ((grid[c].walls & 4) == 0)){exits.add(d);}
    if(l!=-1 && ((grid[c].walls & 8) == 0)){exits.add(l);}
    return exits;
  }
  
  void markVisited(int i, int j){ grid[index(i,j)].visited = true;}
  void markStart(int i, int j){start_cell = index(i,j);}
  void markEnd(int i, int j){end_cell = index(i,j);};
  void unvisitAll(){ for(Cell cell : grid){cell.visited = false;} }
  
  void addWallBetween(int i1, int j1, int i2, int j2){
    int x1 = min(i1,i2);
    int x2 = max(i1,i2);
    int y1 = min(j1,j2);
    int y2 = max(j1,j2);
    int index1 = index(x1,y1);
    int index2 = index(x2,y2);
    if(x2-x1 == 1 && y1==y2){//horizontal
      if(index1 != -1){grid[index1].walls |= 2;} //right wall of left cell
      if(index2 != -1){grid[index2].walls |= 8;} //left wall of right cell
    } else if (y2 - y1 == 1 && x1==x2) {//vertical
      if(index1 != -1){grid[index1].walls |= 4;} //bottom wall of top cell
      if(index2 != -1){grid[index2].walls |= 1;} //top wall of bottom cell
    } else {
      println("Bad wall request.");
    }
  }
  
  void removeWallBetween(int i1, int j1, int i2, int j2){
    int x1 = min(i1,i2);
    int x2 = max(i1,i2);
    int y1 = min(j1,j2);
    int y2 = max(j1,j2);
    int index1 = index(x1,y1);
    int index2 = index(x2,y2);
    if(x2-x1 == 1 && y1==y2){//horizontal
      if(index1 != -1){grid[index1].walls &= 13;} //right wall of left cell
      if(index2 != -1){grid[index2].walls &= 7;} //left wall of right cell
    } else if (y2 - y1 == 1 && x1==x2) {//vertical
      if(index1 != -1){grid[index1].walls &= 11;} //bottom wall of top cell
      if(index2 != -1){grid[index2].walls &= 14;} //top wall of bottom cell
    } else {
      println("Bad wall request.");
    }
  }
  
  boolean removeRandomWall(){
    int direction = 2 << (int)random(2);//chooses "right" or "down" in wall language
    for(int i=0; i<100; i++){
      int choice = (int)random(grid.length);
      if(direction == 2 && grid[choice].x == cell_width - 1){continue;}//if cell on right column, try again
      if(direction == 4 && grid[choice].y == cell_height - 1){continue;}//if cell on bottom row, try again
      if ((grid[choice].walls & direction) != 0){//if cell has walls in the right direction
        if(direction==2){//smash right
          removeWallBetween(grid[choice].x,grid[choice].y,grid[choice + 1].x,grid[choice + 1].y);
        } else {//smash down
          removeWallBetween(grid[choice].x,grid[choice].y,grid[choice + cell_width].x,grid[choice + cell_width].y);
        }
        return true;
      }
    }
    return false;
  }
  
  void show(boolean highlightMouse){
    float dx = (float)width / (float)(cell_width);
    float dy = (float)height / (float)(cell_height);
    int mx = (int)(mouseX/dx);
    int my = (int)(mouseY/dy);
    for(int i=0; i<grid.length; i++){
      Cell cell = grid[i];
      float x = cell.x * dx;
      float y = cell.y * dy;
      pushStyle();
        noStroke();
        if(i==start_cell){
            fill(200,0,0);
        } else if (i==end_cell){
            fill(0,80,0);
        } else if(highlightMouse && cell.x==mx && cell.y==my){
            fill(155,240,255);
        } else if(cell.visited){ 
            fill(visited_color);
        } else {
            fill(cell_color);
        }
        rect(x,y,dx,dy);
      popStyle();
    }
    
    for(Cell cell : grid){
      float x = cell.x * dx;
      float y = cell.y * dy;
      pushStyle();
        stroke(wall_color);
        strokeCap(PROJECT);
        strokeWeight(min(dx,dy)*0.1f);
        if( (cell.walls & 1) == 1){ line(x,y,x+dx,y); }//top
        if( (cell.walls & 2) == 2){ line(x+dx,y,x+dx,y+dy); }//right
        if( (cell.walls & 4) == 4){ line(x,y+dy,x+dx,y+dy); }//bottom
        if( (cell.walls & 8) == 8){ line(x,y,x,y+dy); }//left
      popStyle();
    }
  }
}
