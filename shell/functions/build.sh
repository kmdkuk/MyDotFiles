
function build_cpp() {
    g++ -std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -L/opt/boost/gcc/lib -I/opt/ac-library -o ./a.out $1
    
    result=$?
    if [ $result -ne 0 ];then
        echo -e "[\e[31m-\e[0m] compile failed"
    else
        echo -e "[\e[32m+\e[0m] successful complie"
    fi
}

function build() {
    case "$1" in
        # *.c ) run_c $1 ;;
        *.cpp ) build_cpp $1 ;;
        # *.java ) run_java $1 ;;
        # *.py ) run_py $1 ;;
    esac
}
