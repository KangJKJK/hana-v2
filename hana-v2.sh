#!/bin/bash

# 환경 변수 설정
export WORK="/root/hanafuda"

# 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # 색상 초기화

echo -e "${GREEN}Hana 봇을 설치합니다.${NC}"
echo -e "${GREEN}스크립트작성자: https://t.me/kjkresearch${NC}"
echo -e "${GREEN}출처: https://github.com/nadirasaid8/hanafuda${NC}"

echo -e "${GREEN}설치 옵션을 선택하세요:${NC}"
echo -e "${YELLOW}1. Hana 봇 새로 설치${NC}"
echo -e "${YELLOW}2. 재실행하기${NC}"
read -p "선택: " choice

case $choice in
  1)
    echo -e "${GREEN}Hanafuda 봇을 새로 설치합니다.${NC}"

    # 사전 필수 패키지 설치
    echo -e "${YELLOW}시스템 업데이트 및 필수 패키지 설치 중...${NC}"
    sudo apt update
    sudo apt install -y git

    echo -e "${YELLOW}작업 공간 준비 중...${NC}"
    if [ -d "$WORK" ]; then
        echo -e "${YELLOW}기존 작업 공간 삭제 중...${NC}"
        rm -rf "$WORK"
    fi

    # GitHub에서 코드 복사
    echo -e "${YELLOW}GitHub에서 코드 복사 중...${NC}"
    git clone https://github.com/nadirasaid8/hanafuda
    cd "$WORK"

    # 사용자에게 네트워크 선택 요청
    echo -e "${GREEN}어떤 네트워크를 사용하시겠습니까?${NC}"
    echo -e "${YELLOW}1. Arbitrum${NC}"
    echo -e "${YELLOW}2. Base${NC}"
    read -p "선택 (1 또는 2): " network_choice

    # 선택에 따라 rpc_url 수정
    if [ "$network_choice" -eq 1 ]; then
        sed -i 's|"rpc_url": ".*"|"rpc_url": "https://arb1.arbitrum.io/rpc"|' $WORK/config.json
    elif [ "$network_choice" -eq 2 ]; then
        sed -i 's|"rpc_url": ".*"|"rpc_url": "https://mainnet.base.org"|' $WORK/config.json
    else
        echo -e "${RED}잘못된 선택입니다. 기본값으로 Base 네트워크를 사용합니다.${NC}"
        sed -i 's|"rpc_url": ".*"|"rpc_url": "https://mainnet.base.org"|' $WORK/config.json
    fi

    # 파이썬 및 필요한 패키지 설치
    echo -e "${YELLOW}시스템 업데이트 및 필수 패키지 설치 중...${NC}"
    sudo apt update
    sudo apt install -y python3 python3-pip
    pip install -r requirements.txt
    sudo ln -s /usr/bin/python3 /usr/bin/python

    # 프라이빗키를 입력받기 위한 초기화
    echo "개인키를 줄바꿈으로 입력하세요. (입력을 종료하려면 엔터를 두 번 누르세요):"

    # 프라이빗키를 저장할 배열 초기화
    private_keys=()

    # 프라이빗키 입력받기
    {
        while IFS= read -r line; do
            # 빈 줄이 두 번 입력되면 종료
            [[ -z "$line" ]] && break
            private_keys+=("$line")  # 배열에 추가
        done
    } 

    # privkey.txt 파일에 저장
    {
        for token in "${private_keys[@]}"; do
            echo "$token"
        done
    } > "$WORK/privkey.txt"

    echo -e "${GREEN}프라이빗키 정보가 privkey.txt 파일에 저장되었습니다.${NC}"

    # 사용자로부터 계정 정보 입력받기
    echo -e "${GREEN}사용자 정보를 입력받습니다.${NC}"
    echo -e "${YELLOW}리프레시 토큰을 얻기위해 다음을 따르세요.${NC}"
    echo -e "${YELLOW}1.https://hanafuda.hana.network/ 에 접속합니다.${NC}"
    echo -e "${YELLOW}2.F12를 누른 후 상단탭에서 애플리케이션을 클릭합니다.${NC}"
    echo -e "${YELLOW}3.좌측탭에서 세션 저장소를 클릭한 후 https://hanafuda를 클립합니다${NC}"
    echo -e "${YELLOW}4.가운데창에서 firebase:auth라는 것을 클릭하시고 sTsTokenManager를 클릭합니다.${NC}"
    echo -e ""

    # 리프레시 토큰을 입력받기 위한 초기화
    echo "따옴표를 제외한 리프레시 토큰을 줄바꿈으로 입력하세요. (입력을 종료하려면 엔터를 두 번 누르세요):"

    # 리프레시 토큰을 저장할 배열 초기화
    refresh_tokens=()

    # 리프레시 토큰 입력받기
    {
        while IFS= read -r line; do
            # 빈 줄이 두 번 입력되면 종료
            [[ -z "$line" ]] && break
            refresh_tokens+=("$line")  # 배열에 추가
        done
    } 

    # tokens.txt 파일에 저장
    {
        for token in "${refresh_tokens[@]}"; do
            echo "$token"
        done
    } > "$WORK/tokens.txt"

    echo -e "${GREEN}리프레시 토큰 정보가 data.txt 파일에 저장되었습니다.${NC}"

    echo -e "${GREEN}해당 사이트에 가입을 진행해주세요: https://hanafuda.hana.network/dashboard${NC}"
    read -p "가입을 하셨다면 엔터를 눌러주세요.: "
    echo -e "${GREEN}해당 사이트에서 최초1회 Deposit을 진행하세요(0.5불~1불): https://hanafuda.hana.network/deposit${NC}"
    read -p "Deposit을 하셨다면 엔터를 눌러주세요.: "

    # 봇 구동
    python3 main.py
    ;;
    
  2)
    echo -e "${GREEN}Hanafuda 봇을 재실행합니다.${NC}"
    
    cd "$WORK"
    sudo ln -s /usr/bin/python3 /usr/bin/python

    # 봇 구동
    python3 main.py
    ;;

  *)
    echo -e "${RED}잘못된 선택입니다. 다시 시도하세요.${NC}"
    ;;
