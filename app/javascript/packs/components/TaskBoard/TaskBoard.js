import React, { useEffect, useState } from 'react';
import KanbanBoard from '@lourenci/react-kanban';
import { propOr } from 'ramda';
import { Add } from '@material-ui/icons';
import { Fab } from '@material-ui/core';

import Task from '../Task';
import TasksRepository from 'repositories/TasksRepository';
import ColumnHeader from '../ColumnHeader';
import AddPopup from '../AddPopup';
import EditPopup from '../EditPopup';
import TaskForm from 'forms/TaskForm';

import useStyles from './useStyles.js';

const STATES = [
  { key: 'new_task', value: 'New' },
  { key: 'in_development', value: 'In Dev' },
  { key: 'in_qa', value: 'In QA' },
  { key: 'in_code_review', value: 'in CR' },
  { key: 'ready_for_release', value: 'Ready for release' },
  { key: 'released', value: 'Released' },
  { key: 'archived', value: 'Archived' },
];

const initialBoard = {
  columns: STATES.map((column) => ({
    id: column.key,
    title: column.value,
    cards: [],
    meta: {},
  })),
};

const TaskBoard = () => {
  const styles = useStyles();

  const [board, setBoard] = useState(initialBoard);
  const [boardCards, setBoardCards] = useState([]);

  const loadColumn = (state, page, perPage) => {
    return TasksRepository.index({
      q: { stateEq: state },
      page,
      perPage,
    });
  };

  const loadColumnInitial = (state, page = 1, perPage = 10) => {
    loadColumn(state, page, perPage).then(({ data }) => {
      setBoardCards((prevState) => {
        return {
          ...prevState,
          [state]: { cards: data.items, meta: data.meta },
        };
      });
    });
  };

  const loadColumnMore = (state, page = 1, perPage = 10) => {
    loadColumn(state, page, perPage).then(({ data }) => {
      setBoardCards((prevState) => {
        return {
          ...prevState,
          [state]: {
            cards: prevState[state].cards.concat(data.items),
            meta: data.meta,
          },
        };
      });
    });
  };

  const generateBoard = () => {
    const newBoard = {
      columns: STATES.map(({ key, value }) => {
        return {
          id: key,
          title: value,
          cards: propOr({}, 'cards', boardCards[key]),
          meta: propOr({}, 'meta', boardCards[key]),
        };
      }),
    };

    setBoard(newBoard);
  };

  const loadBoard = () => {
    STATES.map(({ key }) => loadColumnInitial(key));
  };

  useEffect(() => loadBoard(), []);
  useEffect(() => generateBoard(), [boardCards]);

  const handleCardDragEnd = (task, source, destination) => {
    const transition = task.transitions.find(({ to }) => {
      return destination.toColumnId === to;
    });
    if (!transition) {
      return null;
    }

    return TasksRepository.update(task.id, { stateEvent: transition.event })
      .then(() => {
        loadColumnInitial(destination.toColumnId);
        loadColumnInitial(source.fromColumnId);
      })
      .catch((error) => {
        alert(`Move failed! ${error.message}`);
      });
  };

  const MODES = {
    ADD: 'add',
    NONE: 'none',
    EDIT: 'edit',
  };

  const [mode, setMode] = useState(MODES.NONE);
  const [openedTaskId, setOpenedTaskId] = useState(null);

  const handleOpenAddPopup = () => {
    setMode(MODES.ADD);
  };

  const handleOpenEditPopup = (task) => {
    setOpenedTaskId(task.id);
    setMode(MODES.EDIT);
  };

  const handleClose = () => {
    setMode(MODES.NONE);
    setOpenedTaskId(null);
  };

  const loadTask = (id) => {
    return TasksRepository.show(id).then(({ data: { task } }) => task);
  };

  const handleTaskCreate = (params) => {
    const attributes = TaskForm.attributesToSubmit(params);

    return TasksRepository.create(attributes).then(({ data: { task } }) => {
      loadColumnInitial(task.state);
      handleClose();
    });
  };

  const handleTaskUpdate = (task) => {
    const attributes = TaskForm.attributesToSubmit(task);

    return TasksRepository.update(task.id, attributes).then(() => {
      loadColumnInitial(task.state);
      handleClose();
    });
  };

  const handleTaskDestroy = (task) => {
    return TasksRepository.destroy(task.id).then(() => {
      loadColumnInitial(task.state);
      handleClose();
    });
  };

  return (
    <>
      <Fab
        className={styles.addButton}
        color="primary"
        aria-label="add"
        onClick={handleOpenAddPopup}
      >
        <Add />
      </Fab>
      {mode === MODES.ADD && (
        <AddPopup onCreateCard={handleTaskCreate} onClose={handleClose} />
      )}
      {mode === MODES.EDIT && (
        <EditPopup
          cardId={openedTaskId}
          onClose={handleClose}
          onCardDestroy={handleTaskDestroy}
          onLoadCard={loadTask}
          onCardUpdate={handleTaskUpdate}
        />
      )}
      <KanbanBoard
        disableColumnDrag
        renderCard={(card) => (
          <Task onClick={handleOpenEditPopup} task={card} />
        )}
        onCardDragEnd={handleCardDragEnd}
        renderColumnHeader={(column) => (
          <ColumnHeader column={column} onLoadMore={loadColumnMore} />
        )}
      >
        {board}
      </KanbanBoard>
    </>
  );
};

export default TaskBoard;
