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

`install-mdformat` 다음에 저장소 실행 파일로 정렬한다. 전체 writer는 Git이 추적하거나 ignore하지 않은 일반 파일을 고른다.
변경 선택과 읽기 전용 검사 계약은 아래의 채택 내용을 따른다.

## Python 실행·변경 검사·CI 채택 — 2026-10-23

구현·독립 리뷰 요구 등급은 strong이며 리뷰는 구현자와 분리한다.
설치 전 재사용 검사와 설치 후 검사는 실제 venv의 Python 3.11 이상을 요구한다.
새 설치에서만 unset `UV_PYTHON`에 `>=3.11`을 적용하고 명시된 빈 값도 보존한다.
건강한 최신 venv는 더 낮은 명시 요청이 있어도 재사용한다. 도구 pin은 그대로다.

`format-md-check`는 `MDFORMAT_BASE`(기본 origin/master) merge-base 이후 커밋,
index, 작업트리 및 비추적 일반 Markdown을 수정 없이 검사한다.
Git·formatter 실패를 전파하고 공백·개행·선행 대시 인자를 보존한다.
symlink는 Windows index mode 120000 표현까지 제외하되 실제 일반 파일 타입 변경은
선택한다. staged 내용과 작업 파일이 다르면 index를 수정하지 않고 실패한다.
`fmt-md`/`format-md`는 전체 writer이며 `format-md-all-check`는 명시적 전체 검사다.

`quality`는 기존 Go fmt·lint·test에 변경 Markdown 검사와 installer·selector
회귀 검사를 더한다. `.github/workflows/mdformat.yml`은 Linux·Windows에서 실제
설치·launcher·선택기 smoke를 실행한다. 작업 브랜치는 매번 origin/master,
PR은 대상 SHA, trunk push는 이전 SHA, 수동 실행은 전체 검사를 기준으로 한다.
10분 CI job 제한은 초기 정책값이며 상세 메트릭 설계는 후속 범위다.
Windows 실제 성공 여부는 ISSUE-352 campaign 검증 기록으로 구분하며 POSIX 모의
fixture 결과로 대체하지 않는다. 공개 API·manifest schema는 추가하지 않는다.
