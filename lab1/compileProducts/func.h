int find_substr(char* str, char* pattern, int len1, int len2)
{
    int pos = -1;
    for (int i = 0; i < len1; i++)
    {
    	for(int j = 0; j < len2; j++)
    	{
    		if (str[i + j] != pattern[j])
    		{
    			break;
			}
			else if(j == len2 - 1)
			{
				pos = i;
				break;
			}
		}
		if(pos != -1) break;
	}
	return pos;
}

