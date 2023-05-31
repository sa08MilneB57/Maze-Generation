Maze maze;
MazeBuilder bob;
MazeSolver alice;
boolean building_complete = false;
boolean start_chosen = false;
boolean end_chosen = false;
boolean maze_solved = false;
boolean pruning = false;
int pruneCount = 0;

void setup(){
  //size(800,600);
  fullScreen();
  //frameRate(60);
  maze = new Maze(40,23);
  bob = new MazeBuilder(maze);
  maze.show(false);
  bob.show();
}

void draw(){  
  if(!building_complete){
    maze.show(false);
    building_complete = bob.step();
    bob.show();
    if(building_complete){maze.unvisitAll();pruning=true;}
  } else if(pruning){
    maze.removeRandomWall();
    pruneCount++;
    if(pruneCount==200){pruning = false;}
    maze.show(false);
  }else if(!(start_chosen && end_chosen)) {
    maze.show(true);
    maze.markStart((int)random(maze.cell_width),(int)random(maze.cell_height));
    maze.markEnd((int)random(maze.cell_width),(int)random(maze.cell_height));
    start_chosen = true;
    end_chosen = true;
    
    //if(keyPressed){
    //  if(key=='s' || key=='S'){
    //    maze.markStart( (int)(((float)mouseX/width)*maze.cell_width) ,(int)(((float)mouseY/height)*maze.cell_height));
    //    start_chosen = true;
    //  } else if (key=='e'||key=='E'){
    //    maze.markEnd( (int)(((float)mouseX/width)*maze.cell_width) ,(int)(((float)mouseY/height)*maze.cell_height));
    //    end_chosen = true;        
    //  }
    //}
    if(start_chosen && end_chosen){
      alice = new MazeSolver(maze);
      alice.getTarget();
      //frameRate(12);
    }
  } else if(!maze_solved){
    maze.show(false);
    maze_solved = alice.step();
    alice.show();
  } else {
    maze_solved = false;
    start_chosen = false;
    end_chosen = false;
    maze.unvisitAll();
  }
}
