#!/bin/bash

REPOSITORY_NAME="insignagency/capistranoci";

# All "capistrano version;node version" combinations
# Enter one line per combination.
# For node version use only exact version.
read -r -d '' COMBINATIONS << EOM
3.10.1;6.11.3
3.10.1;7.10.1
3.10.1;10.17.0
3.6.1;10.17.0
EOM

GLOBALSTARTTIME=$(date +%s);

for COMBINATION in $COMBINATIONS
    do
        COMBINATION_PARTS=($(echo -n $COMBINATION | tr ';' ' '));

        # Build part
        echo "Building image ${REPOSITORY_NAME}:cap${COMBINATION_PARTS[0]}-node${COMBINATION_PARTS[1]}";

        BUILDSTARTTIME=$(date +%s);

        docker build -q -t ${REPOSITORY_NAME}:"cap${COMBINATION_PARTS[0]}-node${COMBINATION_PARTS[1]}" \
            --no-cache \
            --build-arg CAPISTRANO_VERSION="${COMBINATION_PARTS[0]}" \
            --build-arg NODE_VERSION="${COMBINATION_PARTS[1]}" \
            . ;

        BUILDENDTIME=$(date +%s);
        TIMEDIFF=$(python -c "print(${BUILDENDTIME} - ${BUILDSTARTTIME})");
        echo "Build completed (${TIMEDIFF}s)"

        # Push part.
        echo "Pushing image ${REPOSITORY_NAME}:cap${COMBINATION_PARTS[0]}-node${COMBINATION_PARTS[1]}";

        PUSHSTARTTIME=$(date +%s);

        docker push ${REPOSITORY_NAME}:"cap${COMBINATION_PARTS[0]}-node${COMBINATION_PARTS[1]}";

        PUSHENDTIME=$(date +%s);
        TIMEDIFF=$(python -c "print(${PUSHENDTIME} - ${PUSHSTARTTIME})");
        echo "Push completed (${TIMEDIFF}s)"
    done

GLOBALENDTIME=$(date +%s);
TIMEDIFF=$(python -c "print(${GLOBALENDTIME} - ${GLOBALSTARTTIME})");
echo "Time elapsed : ${TIMEDIFF}s"