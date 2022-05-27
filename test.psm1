function throw1 {
    throw 1
}

function error1 {
    write-error some error
}

function wrapper {
    try {
        throw1
        error1
    }
    catch {
        $_.Exception.Message
    }
}

wrapper