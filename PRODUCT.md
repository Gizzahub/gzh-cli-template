# Product Goals (No-PRD)

**Project**: gzh-cli-template (project scaffold — 소비되지 않는 리포)
**Doc Type**: Goals + Constraints + Quality Gates
**Status**: Active
**Last Updated**: 2026-07-16

______________________________________________________________________

## Product Intent

gzh-cli-template is the **starting point for a new gzh-cli family repository**.
It:

- ships a working skeleton (cobra CLI + `.make/*.mk` + `.golangci.yml` + CI +
  docs) that already satisfies the GUIDELINES §3 baseline,
- is turned into a real repo by `scripts/init-project.sh`, which substitutes
  `__PROJECT_NAME__`-style tokens,
- and is **normative, not just exemplary** — GUIDELINES §1 cites this repo's
  `.make/*.mk` as the family's Makefile pattern.

This is a util project — a single PRODUCT.md is sufficient. It replaces a PRD.

| 제공하는 것 (Is)                              | 되지 않을 것 (Is Not)                       |
| --------------------------------------------- | ------------------------------------------- |
| 신규 패밀리 리포의 시작 골격                  | 라이브러리 (import되지 않는다)              |
| 토큰 치환 부트스트랩 스크립트                 | 대화형 스캐폴딩 도구·제너레이터 엔진        |
| `.make/*.mk` 등 패밀리 표준 패턴의 기준 구현  | 다목적 Go 템플릿 (패밀리 전용)              |
| GUIDELINES §3 베이스라인 충족 예시            | 런타임 프레임워크                           |

______________________________________________________________________

## Goals (Measurable Targets)

G1. **Bootstrap correctness**

- Target: `scripts/init-project.sh`가 macOS·Linux 양쪽에서 성공한다
- 현재 **macOS 실패**. GNU 전제로 `sed -i` 뒤에 접미사 인자가 없어 BSD sed가
  거부하며, **중도에 죽는다** — `mv cmd/__PROJECT_NAME__`은 이미 성공한 뒤라
  리포가 반쯤 치환된 상태로 남는다. **최우선 과제다**

G2. **Zero placeholder residue**

- Target: 부트스트랩 후 `__PROJECT_NAME__`·`__PROJECT_DESC__` 등 토큰 잔여 0건
- 현재 28개 파일에 102개 토큰이 있고, 치환 규칙은 소문자 토큰 하나뿐이다.
  `GZ___PROJECT_NAME___DEBUG`(8곳)는 `GZ_mytool_DEBUG`가 되어 환경변수 관례를
  깬다 — 대문자 토큰 규칙이 필요하다

G3. **Generated repo resolves its dependencies**

- Target: 생성된 리포가 devbox 밖에서 `go mod download` 성공
- 현재 **불가능**. `go.mod`에 `replace github.com/gizzahub/gzh-cli-core =>
  ../gzh-cli-core`가 **커밋되어 있고**, core v0.1.0은 미공개다. GUIDELINES §2
  ("replace 지시자는 로컬 개발 전용")를 템플릿 자신이 위반하며, 위반을 신규 리포마다
  복제한다

G4. **Version consistency**

- Target: Go 버전 선언이 리포 안에서 하나로 일치하고 devbox 툴체인에 정렬된다
- 현재 **3중 불일치** — `go.mod` 1.25.7 / `.golangci.yml` 1.24 / CI 1.26.4

G5. **Baseline exemplar**

- Target: GUIDELINES §3 베이스라인 8행 전부 충족 (기준 구현이므로 예외 없음)
- 현재 **5/8** — `docs/.claude-context/`·`PRODUCT.md`(본 문서로 해소)·`tasks/`
  gitignore 미비

______________________________________________________________________

## Non-Goals (Explicitly Out of Scope)

- No 라이브러리 — 어떤 리포도 이 리포를 import하지 않는다. 복사의 원본일 뿐이다
- No 범용 Go 템플릿 — gzh-cli 패밀리 관례(`.make/*.mk`, cobra, core 의존)를 전제한다
- No 대화형 스캐폴딩 엔진 — 토큰 치환 셸 스크립트 한 개를 유지한다
  (`cookiecutter`·`yeoman` 류 도입 금지 — SOUL 게이트 1)
- No 런타임 기능 — 생성된 CLI의 명령은 예시이며 제품 기능이 아니다
- No 패밀리 밖 사용자 지원

______________________________________________________________________

## Guardrails and Technical Constraints

**Architecture**

- 골격은 패밀리 표준을 **그대로** 따른다 — 템플릿의 일탈은 신규 리포 전부로 복제된다
- `.make/*.mk`는 GUIDELINES §1이 참조하는 기준 구현이다. 변경 시 패밀리 전체
  영향을 검토한다

**Dependency Boundaries**

- `gzh-cli-core`만 의존 가능; 다른 feature 라이브러리 의존 금지 (GUIDELINES §2)
- **`replace` 지시자는 커밋하지 않는다** — 로컬 개발 전용이다 (G3)

**Compatibility**

- Go 버전 SSoT는 devbox `mise.toml`이다. 템플릿의 `go.mod`·`.golangci.yml`·CI는
  단일 값으로 정렬한다 (G4)

**Safety**

- `scripts/init-project.sh`는 in-place로 파일을 이동·재작성한다. 실패 시 리포가
  반쯤 치환된 상태로 남으므로, **부분 실패에서 원복 가능해야 한다** (G1)
- 이식성 있는 sed 사용을 강제한다 (`sed -i.bak` + 정리, 또는 임시파일 경유)

**Convention Drift (문서화된 예외)**

- 본 리포의 `make check`는 vet + lint만 돌고 **테스트를 포함하지 않는다** (테스트는
  `make quality`). devbox 관례(`check` = fmt + lint + test)와 다르므로, 정렬하거나
  이 예외를 유지하는 근거를 여기에 남긴다 — 기준 구현의 불일치는 패밀리로 퍼진다

______________________________________________________________________

## Quality Gates (Release Readiness)

**Bootstrap**

- `scripts/init-project.sh`가 macOS·Linux에서 성공하고 토큰 잔여 0건 (G1·G2)
- 생성된 리포가 devbox 밖에서 `go mod download` + `make build` 성공 (G3)

**Build and Lint**

- `make quality` (fmt + lint + test) pass with no warnings

**Testing**

- 커버리지 >= 80% (baseline 기준 구현으로서의 목표)

**Docs**

- README·CLAUDE.md가 실제 스크립트 동작과 일치

______________________________________________________________________

## Decision Rules

- **템플릿의 결함은 신규 리포 전부에 복제된다** — 여기서의 "사소한 불일치"는
  사소하지 않다. 패밀리 표준과의 일탈은 문서화된 예외를 요구한다
- **`replace` 지시자를 커밋하지 않는다** (GUIDELINES §2, G3)
- 부트스트랩 스크립트는 이식성(BSD/GNU) 검증 없이 머지될 수 없다 (G1)
- 스캐폴딩 프레임워크 도입은 SOUL 게이트 1(재발명·과잉설계 금지)에서 거절된다
- 새 기능은 SOUL.md 4-게이트(틈 · 라이브러리 · 대량/전환 · 날카로움)를 통과해야 한다
- Quality Gates 미충족 시 릴리스는 차단된다

______________________________________________________________________

**End of Document**
