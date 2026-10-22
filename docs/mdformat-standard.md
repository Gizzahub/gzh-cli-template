# Markdown formatter 계약

ISSUE-352 구현 요구 등급은 strong이다. 독립 리뷰는 구현과 다른 주체가
strong 이상으로 한다. 이 문서는 이 작업 트리에 넣은 Make 계약만 적는다.
설치, 회귀, `make quality`, 생성 프로젝트 bootstrap 결과는 없다.

## 고정 묶음

mdformat 1.0.0, mdformat-gfm 1.0.0, mdformat-frontmatter 2.1.2.
하위 의존성 다섯 줄은 `.make/mdformat-constraints.txt`이고
gzh-cli-gitforge 사본이다. mdformat-tables는 포함하지 않는다.

## install-mdformat

`uv tool install`로 `bin/tools`에 설치한다. `--version` 한 줄의 세 항목을
플러그인 순서와 무관하게 확인하고, 도구 venv 인터프리터로 constraints의
`이름==버전` 다섯 줄을 확인한다. 버전 출력은 변수에 담은 뒤 검사한다.
버전 명령이 실패하면 그 실패가 파싱 결과로 바뀌지 않는다. 둘 중 하나라도
어긋나면 재설치하고, 재설치 후에도 다르면 실패한다. uv가 없으면 실패한다.

## fmt-md

`install-mdformat` 다음에 저장소 실행 파일로 정렬한다. Git이 추적하거나
ignore하지 않은 일반 `.md`만 고른다. symlink, 디렉터리, ignored 경로는
제외한다. 경로는 NUL로 넘기고, `./` 접두사로 `-`로 시작하는 이름을
옵션과 구분한다. Bash `pipefail`과 NUL xargs를 쓰며 Git과 formatter
실패는 Make로 전달된다. 완료 메시지는 그 다음이다.

같은 runner에 `changed` 분기가 있다. 이 저장소의 target은 `all`만 호출한다.
변경분 검사 target, 전체 Markdown 게이트, 공개 API, 스키마는 없다.
markdownlint pin, Go 도구 pin, 그 밖 레시피는 그대로다. 기존 Markdown
본문은 이 변경에서 고치지 않는다.
