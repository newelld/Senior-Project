#include <stdio.h>
#include <connect4_engine.h>

int main(int argc, char *argv[])
{
	int keep_playing = 1;
	int player = 0;
	int rows;
	int cols;
	int l2w;
	int board[20][20];
    
    switch(argc)
    {
    	case 2:
    		init(argv[1], argv[2]);
    		rows = argv[1];
    		cols = argv[1];
    		l2w = argv[2];
			board[rows][cols] = {{-1}};
    		break;
    	case 3:
    		init(argv[1], argv[2], argv[3]);
    		rows = argv[1];
    		cols = argv[2];
    		l2w = argv[3];
    		board[rows][cols] = {{-1}};
    		break;
    	default:
    		init(8, 8, 4);
    		rows = 8;
    		cols = 8;
    		l2w = 4;
    		board[rows][cols] = {{-1}};
    }
    
    while(keep_playing != 99)
    {
    	printf("Player %i, please select a coloumn or type '99' to quit.\n", player);
    	scanf("%c", &keep_playing);
    	
    	if(keep_playing == 99)return 0;
        
    	place_token(player, keep_playing, rows, cols, board);
    	winner(rows, cols, l2w, board);
    	toggle_player();
    }
    return 0;
}

void toggle_player()
{
	if(player == 0)
		player = 1;
	else
		player =0;
}