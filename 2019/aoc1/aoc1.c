#include <stdio.h>
#include <stdlib.h>

int main(){
  long ans = 0;
  char buffer[1000];
  FILE *data = fopen("./data", "r");
  if(data != NULL){

    char c;
    int i = 0;
    while((c = getc(data)) != EOF){
      if(c == '\n'){
        buffer[i] = 0;

        for(int num = atoi(buffer)/3-2; num > 0; num = num/3-2){
          ans += num;
        }
        i = 0;
      }
      buffer[i++] = c;
    }

  }
  printf("%ld", ans);

  fclose(data);
}
