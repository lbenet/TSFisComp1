# Respuestas para los ejercicios de [learngitbranching.js.org](https://learngitbranching.js.org/)
## Main

En este documento se describen soluciones a los distintos problemas. Estas soluciones no son todas óptimas de acuerdo con el simulador.

1. Secuencia introductoria

    1. Introducción a los commits de Git

        ```shell
            $ git commit
            $ git commit
        ```

    2. Brancheando [sic] en Git

        ```shell
            $ git branch bugFix
            $ git checkout bugFix
        ```

    3. Mergeando [sic] en Git

        ```shell
            $ git branch bugFix
            $ git checkout bugFix
            $ git commit
            $ git checkout master
            $ git commit
            $ git merge bugFix
        ```

    4. Introducción a rebase

        ```shell
            $ git branch bugFix
            $ git checkout bugFix
            $ git commit
            $ git checkout master
            $ git commit
            $ git checkout bugFix
            $ git rebase master
        ```

2. Acelerando

    1. Desatacheá [sic] tu HEAD

        ```shell
            $ git checkout C4
        ```

    2. Referencias relativas (^)

        ```shell
            $ git checkout bugFix
            $ git checkout HEAD^
        ```

    3. Referencias relativas #2 (~)

        ```shell
            $ git checkout bugFix
            $ git branch -f bugFix HEAD~3
            $ git branch -f master C6
            $ git checkout C1
        ```

    4. Revirtiendo cambios en git [sic]

        ```shell
            $ git reset HEAD^
            $ git checkout pushed
            $ git revert HEAD
            # Obsérvese que reset tiene como argumento al commit al que se quiere regresar, mientras que revert tiene como argumento al commit que se quiere deshacer.
        ```

3. Moviendo el trabajo por allí

    1. Introducción a cherry-pick

        ```shell
            $ git cherry-pick C3 C4 C7
        ```

    2. Introducción al rebase interactivo

        *Nota*: En la versión en español, la opción pick en la simulación está activa por defecto en todos los commits: "hacer pick" en un commit descarta el mismo. Se asume que esto sucede en esta solución.

        ```shell
            $ git rebase -i C1
            # En la ventana, hacer lo siguiente:
            #   1. Hacer pick en C2. (Descarta el commit C2.)
            #   2. Colocar los siguientes commits de arriba a abajo en la lista en el orden siguiente: C3, C5 y C4.
        ```

4. Bolsa de gatos

    1. Tomando un único commit

        ```shell
            $ git checkout master
            $ git cherry-pick C4
        ```

    2. Haciendo malabares con los commits

        ```shell
            $ git rebase -i C1
            # En la ventana, hacer lo siguiente:
            #   1. Colocar los siguientes commits de arriba a abajo en la lista en el orden siguiente: C3, C2.
            $ git commit --amend
            $ git rebase -i C1
            # En la ventana, hacer lo siguiente:
            #   1. Colocar los siguientes commits de arriba a abajo en la lista en el orden siguiente: C2'', C3'.
            $ git checkout master
            $ git merge caption
        ```

    3. Haciendo malabares con los commits #2

        ```shell
            $ git checkout master
            $ git cherry-pick C2
            $ git commit --amend
            $ git cherry-pick C3
        ```

    4. Tags en git [sic]

        ```shell
            $ git tag v0 C1
            $ git tag v1 C2
            $ git checkout v1
        ```

    5. Git Describe [sic]

        *Nota*: Para acreditar este nivel, sólo se requiere hacer un commit. Este nivel busca ilustrar el uso de `git describe`.

        ```shell
            # Por ejemplo, dentro del simulador el comando:
            $ git describe
            # devuelve:
            v1_2_gc6
            # dónde v1 es el tag más cercano en los ancestros del commit siendo descrito (C6) y 2 es la distancia a dicho tag desde el commit.
            # En este caso, como no se suministra algún argumento al comando, se utiliza el commit en el que se encuentra HEAD. (En este caso, C6.)
            $ git commit
        ```

5. Temas avanzados

    1. Rebaseando [sic] más de 9000 veces

        ```shell
            $ git checkout bugFix
            $ git rebase master
            $ git checkout side
            $ git rebase bugFix
            $ git checkout another
            $ git rebase side
            $ git checkout master
            $ git rebase another
        ```

    2. Múltiples padres

        ```shell
            $ git checkout HEAD~^2~
            # El número después de ^ elige al "segundo" padre del merge, es decir, el último commit de la rama que se usa como argumento en `git merge`.
            $ git branch bugWork
            $ git checkout master
        ```

    3. Ensalada de branches [sic]

        ```shell
            $ git checkout one
            $ git cherry-pick C4 C3 C2
            $ git checkout two
            $ git cherry-pick C5 C4 C3 C2
            $ git branch -f three C2
        ```

## Remote

1. Push & Pull [sic] -- Git [sic] Remotes!

    1. Introducción a clone

        *Nota*: En la simulación, el rol de `git clone` está al revés: en lugar de clonar un repositorio remoto ya existente, crea un repositorio remoto con el trabajo presente.

        ```shell
            $ git clone
        ```

    2. Ramas remotas

        ```shell
            $ git commit
            $ git checkout o/master
            $ git commit
            # El hacer checkout en una rama remota en el repositorio local causa que HEAD no se encuentre atado a ninguna rama, lo que impide la modificación de las ramas remotas en el repositorio local de forma sencilla.
        ```

    3. `git fetch`

        ```shell
            # `git fetch` sólo descarga los commits en el repositorio remoto que no se encuentran en el repositorio local y actualiza las ramas remotas del repositorio con dichos commits. No altera las ramas locales.
            $ git fetch
            # Una vez hecho esto, se pueden usar los comandos locales de Git sobre las ramas remotas en el repositorio local como si se trataran de ramas locales, con la salvedad de lo comentado en el ejercicio anterior.
        ```

    4. `git pull`

        ```shell
            # `git pull` es un método abreviado de `git fetch` para el repositorio remoto y `git merge` de la rama local sobre la rama remota en el repositorio local.
            $ git pull
        ```

    5. Simulando el trabajo en equipo

        *Nota*: `git fakeTeamwork` es un comando exclusivo del simulador para generar commits en repositorios remotos sin que estos commits sean reflejados en el repositorio local sin intervención de otros comandos.

        ```shell
            $ git clone # Crea el remoto en la simulación. Cf. nota en el primer ejercicio de la primer parte de ña sección "Remote".
            $ git fakeTeamwork master 2 # Genera cuatro commits en el repositorio remoto en la rama master.
            $ git commit
            $ git pull
        ```

    6. `git push`

        ```shell
            # `git push`, en principio, es una forma de subir el trabajo local al repositorio remoto y de actualizar las ramas en el mismo.
            $ git commit
            $ git commit
            $ git push
        ```

    7. Historia divergente

        ```shell
            # `git push`, en el caso en el que existan cambios en el repositorio remoto que no se encuentren en el repositorio local y existan cambios en el repositorio local que no se encuentran en el repositorio remoto, no tiene efecto y requiere la inclusión de los cambios remotos al repositorio local antes de hacer la subida del trabajo local.
            # Algunas formas de solucionar este conflicto son mediante el uso de `git rebase` sobre la rama remota en el repositorio local o el uso de `git merge` entre la rama remota y la rama local en el repositorio local. Esto es después de realizar `git fetch` para poder usar el estado actual del repositorio remoto.
            # Un atajo para para hacer `git fetch` seguido de `git rebase` es `git pull --rebase`
            $ git clone
            $ git fakeTeamwork master 1
            $ git commit
            $ git fetch
            $ git rebase o/master
            $ git push
        ```

2. Hasta el origin y más allá -- Git Remotes [sic] avanzado! [sic]

    1. ¡Push Master! [sic]

        ```shell
            $ git checkout master
            $ git pull
            $ git checkout side1
            $ git rebase master
            $ git checkout side2
            $ git rebase side1
            $ git checkout side3
            $ git rebase side2
            $ git checkout master
            $ git rebase side3
            $ git push
        ```

    2. Mergeando [sic] con los remotos

        ```shell
            $ git checkout master
            $ git pull
            $ git checkout side1
            $ git merge master
            $ git checkout side2
            $ git merge side1
            $ git merge side3
            $ git checkout master
            $ git rebase side2
            $ git push
        ```

    3. Trackeando [sic] remotos

        ```shell
            # Una rama local puede estar configurada para hacer "tracking" (seguimiento) sobre una rama remota. Este seguimiento se puede cambiar.
            # Una forma de hacer esto es mediante `git checkout -b`.
            # Otra forma de hacerlo es con `git branch -u`.
            $ git checkout -b side
            $ git commit
            $ git fetch
            $ git rebase o/master
            $ git branch -u o/master
            $ git push
        ```

    4. Parámetros de `git push`

        ```shell
            $ git push origin master
            $ git push origin foo
        ```

    5. ¡Más! [sic] Parámetros de `git push`

        ```shell
            $ git push origin foo^:foo
            $ git push origin master^:foo
            $ git push origin foo:master
        ```

    6. Parámetros de fetch

        ```shell
            # Dotar de referencias con dos puntos a `git fetch` sí actualiza la rama local destino o la crea en caso de no existir.
            $ git fetch origin master^:foo
            $ git fetch origin foo:master
            $ git checkout foo
            $ git merge C6
        ```

    7. Origen de nada

        ```shell
            # Se puede dotar de parámetros vacíos tanto a fetch como a push. En el caso de push, elimina la rama objetivo. En el caso de fetch, crea una nueva rama.
            $ git fetch origin :bar
            $ git push origin :foo
        ```

    8. Parámetros de pull

        ```shell
            $ git pull origin bar:foo
            $ git pull origin master:side
        ```
