import React from "react";

import { Row, Col, ListGroup } from "react-bootstrap";

const NavbarDropdownItem = ({ icon, title, description, time, spacing }) => (
  <ListGroup.Item>
    <Row className="align-items-center g-0">
      <Col xs={2}>{icon}</Col>
      <Col xs={10} className={spacing ? "ps-2" : null}>
        <div>{title}</div>
        <div className="text-muted small mt-1">{description}</div>
        <div className="text-muted small mt-1">{time}</div>
      </Col>
    </Row>
  </ListGroup.Item>
);

export default NavbarDropdownItem;
